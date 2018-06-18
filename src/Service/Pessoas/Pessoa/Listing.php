<?php
namespace App\Service\Pessoas\Pessoa;

use Symfony\Component\HttpFoundation\Request;
use Doctrine\ORM\EntityManager;

class Listing
{
    private $objEntityManager = NULL;
    
    public function __construct(EntityManager $objEntityManager)
    {
        $this->objEntityManager = $objEntityManager;
    }
    
    public function get(int $idPessoa)
    {
        try {
            $objRepositoryPessoa = $this->objEntityManager->getRepository('App\Entity\Pessoas\Pessoa');
            return $objRepositoryPessoa->find($idPessoa);
        } catch (\RuntimeException $e){
            throw $e;
        } catch (\Exception $e){
            throw $e;
        }
    }
    
    public function list(Request $objRequest)
    {
        try {
            $objRepositoryPessoa = $this->objEntityManager->getRepository('App\Entity\Pessoas\Pessoa');
            return $objRepositoryPessoa->findAll();
        } catch (\RuntimeException $e){
            throw $e;
        } catch (\Exception $e){
            throw $e;
        }
    }
}

