<?php
namespace App\Controller\Pessoas;

use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Request;
use App\Service\Pessoas\Pessoa as PessoaService;
use Symfony\Component\Serializer\Serializer;
use Symfony\Component\Serializer\Encoder\XmlEncoder;
use Symfony\Component\Serializer\Encoder\JsonEncoder;
use Symfony\Component\Serializer\Normalizer\ObjectNormalizer;
use App\Entity\Pessoas\Pessoa;

class PessoaController extends Controller
{
    public function postPessoa(Request $objRequest)
    {
        try {
            $objPessoasPessoa = $this->get('pessoas.pessoa');
            if(!$objPessoasPessoa instanceof PessoaService){
                return new JsonResponse(['message'=> 'Class "App\Service\Pessoas\Pessoa not found."'], Response::HTTP_INTERNAL_SERVER_ERROR);
            }

            $objPessoa = $objPessoasPessoa->create($objRequest);
            
            return new JsonResponse(['id'=>$objPessoa->getId()], Response::HTTP_OK);
        } catch (\RuntimeException $e) {
            return new JsonResponse(['mensagem'=>$e->getMessage()], Response::HTTP_PRECONDITION_FAILED);
        } catch (\Exception $e) {
            return new JsonResponse(['mensagem'=>$e->getMessage()], Response::HTTP_INTERNAL_SERVER_ERROR);
        }
    }
    
    public function getPessoa(int $idPessoa)
    {
        try {
            $objPessoasPessoa = $this->get('pessoas.pessoa');
            if(!$objPessoasPessoa instanceof PessoaService){
                return new JsonResponse(['message'=> 'Class "App\Service\Pessoas\Pessoa not found."'], Response::HTTP_INTERNAL_SERVER_ERROR);
            }
            
            $objPessoa = $objPessoasPessoa->get($idPessoa);
            $encoders = array(new XmlEncoder(), new JsonEncoder());
            
            $objObjectNormalizer = new ObjectNormalizer();
        
            $objObjectNormalizer->setCircularReferenceHandler(function (Pessoa $objPessoa) {
                return $objPessoa->getId();
            });
        
            $callbackDateTime = function ($dateTime) {
                return $dateTime instanceof \DateTime
                ? $dateTime->format(\DateTime::ISO8601)
                : '';
            };
                
            $objObjectNormalizer->setCallbacks(array('dataCadastro' => $callbackDateTime, 'dataAniversario' => $callbackDateTime));
            $objObjectNormalizer->setCircularReferenceLimit(1);
            $normalizers = array($objObjectNormalizer);
            
            
            $objSerializer = new Serializer($normalizers, $encoders);
            return new JsonResponse($objSerializer->normalize($objPessoa, 'json'), Response::HTTP_OK);
        } catch (\RuntimeException $e) {
            return new JsonResponse(['mensagem'=>$e->getMessage()], Response::HTTP_PRECONDITION_FAILED);
        } catch (\Exception $e) {
            return new JsonResponse(['mensagem'=>$e->getMessage()], Response::HTTP_INTERNAL_SERVER_ERROR);
        }
    }
    
    public function getPessoas(Request $objRequest)
    {
        try {
            $objPessoasPessoa = $this->get('pessoas.pessoa');
            if(!$objPessoasPessoa instanceof PessoaService){
                return new JsonResponse(['message'=> 'Class "App\Service\Pessoas\Pessoa not found."'], Response::HTTP_INTERNAL_SERVER_ERROR);
            }
            
            $arrayPessoa = $objPessoasPessoa->list($objRequest);
            $encoders = array(new XmlEncoder(), new JsonEncoder());
            
            $objObjectNormalizer = new ObjectNormalizer();
            
            $objObjectNormalizer->setCircularReferenceHandler(function (Pessoa $objPessoa) {
                return $objPessoa->getId();
            });
            
            $callbackDateTime = function ($dateTime) {
                return $dateTime instanceof \DateTime
                ? $dateTime->format(\DateTime::ISO8601)
                : '';
            };
            
            $objObjectNormalizer->setCallbacks(array('dataCadastro' => $callbackDateTime, 'dataAniversario' => $callbackDateTime));
            $objObjectNormalizer->setCircularReferenceLimit(1);
            $normalizers = array($objObjectNormalizer);
            
            
            $objSerializer = new Serializer($normalizers, $encoders);
            return new JsonResponse($objSerializer->normalize($arrayPessoa, 'json'), Response::HTTP_OK);
        } catch (\RuntimeException $e) {
            return new JsonResponse(['mensagem'=>$e->getMessage()], Response::HTTP_PRECONDITION_FAILED);
        } catch (\Exception $e) {
            return new JsonResponse(['mensagem'=>$e->getMessage()], Response::HTTP_INTERNAL_SERVER_ERROR);
        }
    }
    
    public function deletePessoa(int $idPessoa)
    {
        return new JsonResponse(['id'=>['deletePessoa']], Response::HTTP_OK);
    }
    
    public function putPessoa(int $idPessoa)
    {
        return new JsonResponse(['id'=>['putPessoa']], Response::HTTP_OK);
    }
    
    public function patchPessoa(int $idPessoa)
    {
        return new JsonResponse(['id'=>['patchPessoa']], Response::HTTP_OK);
    }
    
}

