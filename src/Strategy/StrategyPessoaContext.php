<?php
namespace App\Strategy;

use Doctrine\Bundle\DoctrineBundle\Registry;
use Symfony\Component\HttpFoundation\Request;

class StrategyPessoaContext
{
    private $objStrategy    = NULL;
    private $objRegistry    = NULL;
    private $objRequest     = NULL;
    
    public function __construct(Registry $objRegistry, Request $objRequest)
    {
        $this->objRegistry  = $objRegistry;
        $this->objRequest   = $objRequest;
    }
    
    public function create()
    {
        try {
            
        } catch (\RuntimeException $e) {
            throw $e;
        } catch (\Exception $e) {
            throw $e;
        }
    }
}

