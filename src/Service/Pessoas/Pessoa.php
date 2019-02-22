<?php
namespace App\Service\Pessoas;

use Doctrine\Bundle\DoctrineBundle\Registry;
use Symfony\Component\HttpFoundation\Request;
use App\Service\Pessoas\Pessoa\Create;
use App\Service\Pessoas\Pessoa\Listing;
use Monolog\Logger;

class Pessoa
{
    private $objEntityManager   = NULL;
    private $objLogger          = NULL;
    
    public function __construct(Registry $objRegistry, Logger $objLogger)
    {
        $this->objEntityManager = $objRegistry->getManager('default');
        $this->objLogger = $objLogger;
    }
    
    public function create(Request $objRequest)
    {
        try {
            $this->objLogger->error('opa', $objRequest->attributes->all());
            $objPessoasPessoaCreate = new Create($this->objEntityManager);
            $objPessoasPessoaCreate->create($objRequest);
            return $objPessoasPessoaCreate->save();
        } catch (\RuntimeException $e){
            throw $e;
        } catch (\Exception $e){
            throw $e;
        }
    }
    
    public function get(int $idPessoa)
    {
        try {
            $objPessoasPessoaListing = new Listing($this->objEntityManager);
            return $objPessoasPessoaListing->get($idPessoa);
        } catch (\RuntimeException $e){
            throw $e;
        } catch (\Exception $e){
            throw $e;
        }
    }
    
    public function list(Request $objRequest)
    {
        try {
            $objPessoasPessoaListing = new Listing($this->objEntityManager);
            return $objPessoasPessoaListing->list($objRequest);
        } catch (\RuntimeException $e){
            throw $e;
        } catch (\Exception $e){
            throw $e;
        }
    }
}

