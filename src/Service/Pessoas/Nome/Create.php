<?php
namespace App\Service\Pessoas\Nome;

use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\Validator\Constraints as Assert;
use Symfony\Component\Validator\Validation;
use Doctrine\ORM\EntityManager;
use App\Entity\Pessoas\Pessoa;
use App\Entity\Pessoas\Nome;
use App\DBAL\Type\Enum\Vogel\TipoNomePessoaType;

class Create
{
    private $objEntityManager   = NULL;
    private $objNome    = NULL;
    private $objPessoa  = NULL;
    
    public function __construct(EntityManager $objEntityManager)
    {
        $this->objEntityManager = $objEntityManager;
    }
    
    public function create(Request $objRequest)
    {
        try {
            $this->validate($objRequest);
            
            $this->objNome = new Nome();
            $this->objNome->setPessoa($this->objPessoa);
            $this->objNome->setNome($objRequest->get('nome', NULL));
            $this->objNome->setTipo($objRequest->get('tipo', NULL));
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
            'choices' => TipoNomePessoaType::getChoices(),
            'message' => 'Selecione um tipo de nome válido.'
        ] );
        
        $objLength = new Assert\Length( [
            'min'           => 3,
            'max'           => 255,
            'minMessage'    => 'Este valor é muito curto. Deve ter {{ limit }} caracteres ou mais.',
            'maxMessage'    => 'Este valor é muito longo. Deve ter {{ limit }} caracteres ou menos.'
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
                    'nome' => new Assert\Required( [
                            $objNotNull,
                            $objNotBlank,
                            $objLength
                        ]
                    ),
                    'idPessoa' => new Assert\Optional( [
                            $objRange
                        ]
                    )
                ]
            ]
        );
        
        $data = [
            'idPessoa'  => $objRequest->get('idPessoa', NULL),
            'tipo'      => $objRequest->get('tipo', NULL),
            'nome'      => $objRequest->get('nome', NULL)
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
        
        if(!($this->objPessoa instanceof Pessoa)){
            $this->objPessoa = $this->objEntityManager->getRepository('App\Entity\Pessoas\Pessoa')->find($objRequest->get('idPessoa', NULL));
            if(!($this->objPessoa instanceof Pessoa)){
                throw new \RuntimeException('Pessoa não localizada.');
            }
        }
    }
    
    /**
     * @return \App\Entity\Pessoas\Pessoa
     */
    public function getPessoa()
    {
        return $this->objPessoa;
    }

    /**
     * @param \App\Entity\Pessoas\Pessoa $objPessoa
     */
    public function setPessoa(Pessoa $objPessoa)
    {
        $this->objPessoa = $objPessoa;
    }
    
    /**
     * @return \App\Entity\Pessoas\Nome
     */
    public function getNome()
    {
        return $this->objNome;
    }
    
    /**
     * @param \App\Entity\Pessoas\Nome $objNome
     */
    public function setNome(Nome $objNome)
    {
        $this->objNome = $objNome;
    }
    
    public function save()
    {
        $this->objEntityManager->persist($this->objNome);
        $this->objEntityManager->flush();
        return $this->objNome;
    }
}
