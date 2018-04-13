<?php
namespace App\Service\Pessoas\Nome;

use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\Validator\Constraints as Assert;
use Symfony\Component\Validator\Validation;
use Doctrine\ORM\EntityManager;
use App\Entity\Pessoas\Pessoa;
use App\Entity\Pessoas\PessoaToPessoa ;
use App\DBAL\Type\Enum\Vogel\TipoRelacionamentoPessoaType;

class Create
{
    private $objEntityManager   = NULL;
    private $objPessoaToPessoa  = NULL;
    private $objPessoaOrigem    = NULL;
    private $objPessoaDestino   = NULL;

    public function __construct(EntityManager $objEntityManager)
    {
        $this->objEntityManager = $objEntityManager;
    }
    
    public function create(Request $objRequest)
    {
        try {
            $this->validate($objRequest);
            $this->objPessoaToPessoa = new PessoaToPessoa();
            $this->objPessoaToPessoa->setTipo($objRequest->get('tipo', NULL));
            $this->objPessoaToPessoa->setPessoaOrigem($this->objPessoaOrigem);
            $this->objPessoaToPessoa->setPessoaDestino($this->objPessoaDestino);
        } catch (\RuntimeException $e){
            throw $e;
        } catch (\Exception $e){
            throw $e;
        }
    }

    private function validate(Request $objRequest)
    {
        $objNotNull = new Assert\NotNull();
        $objNotNull->message = 'Esse valor não deve ser nulo.';
        $objNotBlank = new Assert\NotBlank();
        $objNotBlank->message = 'Esse valor não deve estar em branco.';
        
        $objChoiceTipo = new Assert\Choice( [
            'choices' => TipoRelacionamentoPessoaType::getChoices(),
            'message' => 'Selecione um tipo de nome válido.'
        ] );
        
        $objRange = new Assert\Range( [
            'min'               => 1,
            'max'               => 999999999,
            'minMessage'        => 'Este valor é muito curto. Deve ter {{ limit }} caracteres ou mais.',
            'maxMessage'        => 'Este valor é muito longo. Deve ter {{ limit }} caracteres ou menos.',
            'invalidMessage'    => 'Este valor deve ser um número válido.'
        ] );
        
        $objRecursiveValidator = Validation::createValidatorBuilder()->getValidator();
        
        $objCollection = new Assert\Collection(
            [
                'fields' => [
                    'tipo' => new Assert\Required( [
                            $objNotNull,
                            $objNotBlank,
                            $objChoiceTipo
                        ]
                    ),
                    'idPessoaDestino' => new Assert\Required( [
                            $objNotNull,
                            $objNotBlank,
                            $objRange
                        ]
                    ),
                    'idPessoaOrigem' => new Assert\Optional( [
                            $objNotNull,
                            $objNotBlank,
                            $objRange
                        ]
                    )
                ]
            ]
        );
        
        $data = [
            'idPessoaOrigem'    => $objRequest->get('idPessoaOrigem', NULL),
            'idPessoaDestino'   => $objRequest->get('idPessoaDestino', NULL),
            'tipo'              => $objRequest->get('tipo', NULL)
        ];
        
        $objConstraintViolationList = $objRecursiveValidator->validate($data, $objCollection);
        
        if($objConstraintViolationList->count()){
            $objArrayIterator = $objConstraintViolationList->getIterator();
            $objArrayIterator->rewind();
            $mensagem = '';
            while($objArrayIterator->valid()){
                if($objArrayIterator->key()){
                    $mensagem.= "\n";
                }
                $mensagem.= $objArrayIterator->current()->getPropertyPath().': '.$objArrayIterator->current()->getMessage();
                $objArrayIterator->next();
            }
            throw new \RuntimeException($mensagem);
        }
        
        if(!($this->objPessoaOrigem instanceof Pessoa)){
            $this->objPessoaOrigem = $this->objEntityManager->getRepository('Pessoas:Pessoa')->find($objRequest->get('idPessoaOrigem', NULL));
            if(!($this->objPessoaOrigem instanceof Pessoa)){
                throw new \RuntimeException('Pessoa Origem não localizada.');
            }
        }
        
        if(!($this->objPessoaDestino instanceof Pessoa)){
            $this->objPessoaDestino = $this->objEntityManager->getRepository('Pessoas:Pessoa')->find($objRequest->get('idPessoaDestino', NULL));
            if(!($this->objPessoaDestino instanceof Pessoa)){
                throw new \RuntimeException('Pessoa Destino não localizada.');
            }
        }
    }
    
    /**
     * @return \App\Entity\Pessoas\PessoaToPessoa
     */
    public function getPessoaToPessoa()
    {
        return $this->objPessoaToPessoa;
    }
    
    /**
     * @return \App\Entity\Pessoas\Pessoa
     */
    public function getPessoaOrigem()
    {
        return $this->objPessoaOrigem;
    }
    
    /**
     * @return \App\Entity\Pessoas\Pessoa
     */
    public function getPessoaDestino()
    {
        return $this->objPessoaDestino;
    }
    
    /**
     * @param \App\Entity\Pessoas\PessoaToPessoa $objPessoaToPessoa
     */
    public function setPessoaToPessoa(\App\Entity\Pessoas\PessoaToPessoa $objPessoaToPessoa)
    {
        $this->objPessoaToPessoa = $objPessoaToPessoa;
    }
    
    /**
     * @param \App\Entity\Pessoas\Pessoa $objPessoaOrigem
     */
    public function setPessoaOrigem(\App\Entity\Pessoas\Pessoa $objPessoaOrigem)
    {
        $this->objPessoaOrigem = $objPessoaOrigem;
    }
    
    /**
     * @param \App\Entity\Pessoas\Pessoa $objPessoaDestino
     */
    public function setPessoaDestino(\App\Entity\Pessoas\Pessoa $objPessoaDestino)
    {
        $this->objPessoaDestino = $objPessoaDestino;
    }
    
    public function save()
    {
        $this->objEntityManager->persist($this->objPessoaToPessoa);
        $this->objEntityManager->flush();
        return $this->objPessoaToPessoa;
    }
}
