<?php
namespace App\Controller\Pessoas;

use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Request;
use App\Service\Pessoas\Pessoa as PessoaService;


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
    
    public function getPessoa(int $id)
    {
//         $fractal = new Manager();
        
        // Get data from some sort of source
        // Most PHP extensions for SQL engines return everything as a string, historically
        // for performance reasons. We will fix this later, but this array represents that.
        $books = [
            [
                'id' => '1',
                'title' => 'Hogfather',
                'yr' => '1998',
                'author_name' => 'Philip K Dick',
                'author_email' => 'philip@example.org',
            ],
            [
                'id' => '2',
                'title' => 'Game Of Kill Everyone',
                'yr' => '2014',
                'author_name' => 'George R. R. Satan',
                'author_email' => 'george@example.org',
            ]
        ];
        
//         $resource = new Collection($books, function(array $book) {
//             return [
//                 'id'      => (int) $book['id'],
//                 'title'   => $book['title'],
//                 'year'    => (int) $book['yr'],
//                 'author'  => [
//                     'name'  => $book['author_name'],
//                     'email' => $book['author_email'],
//                 ],
//                 'links'   => [
//                     [
//                         'rel' => 'self',
//                         'uri' => '/books/'.$book['id'],
//                     ]
//                 ]
//             ];
//         });
        
//         $array = $fractal->createData($resource)->toArray();
//         return new JsonResponse($array, Response::HTTP_OK);
        return new JsonResponse(['type'=>['getPessoa::id']], Response::HTTP_OK);
    }
    
    public function getPessoas(Request $objRequest)
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
    
    public function deletePessoa(int $id)
    {
        return new JsonResponse(['id'=>['deletePessoa']], Response::HTTP_OK);
    }
    
    public function putPessoa(int $id)
    {
        return new JsonResponse(['id'=>['putPessoa']], Response::HTTP_OK);
    }
    
    public function patchPessoa(int $id)
    {
        return new JsonResponse(['id'=>['patchPessoa']], Response::HTTP_OK);
    }
}

