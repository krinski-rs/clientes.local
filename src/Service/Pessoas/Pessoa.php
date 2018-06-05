<?php
namespace App\Service\Pessoas;

use Doctrine\Bundle\DoctrineBundle\Registry;
use Symfony\Component\HttpFoundation\Request;
use App\Service\Pessoas\Pessoa\Create;

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
    
    public function list()
    {
        
    }
}

