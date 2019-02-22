<?php
namespace App\EventListener;

use Symfony\Component\HttpKernel\Event\GetResponseEvent;
use Symfony\Component\HttpKernel\HttpKernel;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\RedirectResponse;
use Symfony\Component\HttpKernel\Event\FilterResponseEvent;
use Symfony\Bridge\Monolog\Logger;
use App\Service\SSO\AuthExceptions;
use App\Service\SSO\SSOClient;
use Symfony\Component\HttpKernel\HttpKernelInterface;
use Symfony\Component\DependencyInjection\ParameterBag\ParameterBagInterface;
use Symfony\Component\HttpFoundation\Response;

class SSOAuthEventListener
{
    private $objLogger                  = NULL;
    private $objAuthExceptions          = NULL;
    private $objSSoClient               = NULL;
    private $objParameterBagInterface   = NULL;
    private $corsParameters             = NULL;
    
    public function __construct($cors, Logger $objLogger, AuthExceptions $objAuthExceptions, SSOClient $objSSoClient, ParameterBagInterface $objParameterBagInterface)
    {
        $this->corsParameters           = $cors;
        $this->objLogger                = $objLogger;
        $this->objAuthExceptions        = $objAuthExceptions;
        $this->objSSoClient             = $objSSoClient;
        $this->objParameterBagInterface = $objParameterBagInterface;
    }
    
    public function onKernelRequest(GetResponseEvent $objGetResponseEvent)
    {
        /*
         * Não faça nada se não for o MASTER_REQUEST
         */
        if (HttpKernelInterface::MASTER_REQUEST !== $objGetResponseEvent->getRequestType()) {
            return;
        }
        
        $objRequest = $objGetResponseEvent->getRequest();
        $method  = $objRequest->getRealMethod();
        if ('OPTIONS' === strtoupper($method)) {
            $objResponse = new Response();
            $allowed_origin = array_search($objRequest->headers->get('origin'), $this->corsParameters['allowed_origin']);
            $objResponse->headers->set('Access-Control-Allow-Origin', trim($this->corsParameters['allowed_origin'][$allowed_origin]));
            $objResponse->headers->set('Access-Control-Allow-Credentials', 'true');
            $objResponse->headers->set('Access-Control-Allow-Methods', 'POST,GET,PUT,DELETE,PATCH,OPTIONS');
            $objResponse->headers->set('Access-Control-Allow-Headers', implode(",", $this->corsParameters['allowed_headers']));
            $objResponse->headers->set('Access-Control-Max-Age', 3600);
            $objGetResponseEvent->setResponse($objResponse);
            return ;
        }
        
        if ($objRequest->headers->get('content-type') == 'application/json') {
            $data = json_decode($objGetResponseEvent->getRequest()->getContent(), true);
            if(count($data)){
                reset($data);
                while($dado = current($data)){
                    $this->objLogger->error("POST", array($dado, key($data)));
                    $objRequest->attributes->set(key($data), $dado);
                    next($data);
                }
            }
        }
        
        if(!$this->objSSoClient->me()){
            throw new \Exception('Erro de login.');
        }
        
    }
    
    private function setRedirectToLoginResponse(GetResponseEvent $objGetResponseEvent)
    {
        $request = Request::createFromGlobals();
        if ($request->isXmlHttpRequest() ) {
            $data = array("msg" => "Você precisa estar logado para realizar esta ação");
            $response = new JsonResponse($data, 403);
        } else {
            $response = new RedirectResponse('/login', 302);
        }
        $objGetResponseEvent->setResponse($response);
        $objGetResponseEvent->stopPropagation();
    }
    
    public function onKernelResponse(FilterResponseEvent $objFilterResponseEvent)
    {
        $objRequest = $objFilterResponseEvent->getRequest();
        /*
         * Execute o CORS aqui para garantir que o domínio esteja no sistema
         */
       
        //if (in_array($request->headers->get('origin'), $this->cors)) {
        if (HttpKernelInterface::MASTER_REQUEST !== $objFilterResponseEvent->getRequestType()) {
            return;
        }
        
        $allowed_origin = array_search($objRequest->headers->get('origin'), $this->corsParameters['allowed_origin']);
        $objResponse = $objFilterResponseEvent->getResponse();
        $objResponse->headers->set('Access-Control-Allow-Origin', trim($this->corsParameters['allowed_origin'][$allowed_origin]));
        $objResponse->headers->set('Access-Control-Allow-Credentials', 'true');
        $objResponse->headers->set('Access-Control-Allow-Methods', 'POST,GET,PUT,DELETE,PATCH,OPTIONS');
        $objResponse->headers->set('Access-Control-Allow-Headers', implode(",", $this->corsParameters['allowed_headers']));
    }
}

