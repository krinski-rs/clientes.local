<?php
namespace App\Service\Pessoas;

use Doctrine\Bundle\DoctrineBundle\Registry;
use Symfony\Component\HttpFoundation\Request;
use App\Service\Pessoas\Pessoa\Create;
use App\Service\Pessoas\Pessoa\Listing;

class Pessoa
{
    private $objEntityManager   = NULL;
    
    public function __construct(Registry $objRegistry)
    {
        $this->objEntityManager = $objRegistry->getManager('default');
    }
    
    public function create(Request $objRequest)
    {
        try {
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

