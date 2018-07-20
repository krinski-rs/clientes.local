<?php
namespace App\Service\Pessoas\PessoaToPessoa;

use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\Validator\Constraints as Assert;
use Symfony\Component\Validator\Validation;
use Doctrine\ORM\EntityManager;
use App\Entity\Pessoas\Pessoa as EntityPessoa;
use App\Entity\Pessoas\PessoaToPessoa as EntityPessoaToPessoa;
use App\DBAL\Type\Enum\Vogel\TipoRelacionamentoPessoaType;

class Create
{
    private $objEntityManager   = NULL;
    private $objPessoaToPessoa  = NULL;
    private $objPessoa          = NULL;
    private $objPessoaRelacao   = NULL;

    public function __construct(EntityManager $objEntityManager)
    {
        $this->objEntityManager = $objEntityManager;
    }
    
    public function create(Request $objRequest)
    {
        try {
            $this->validate($objRequest);
            $this->objPessoaToPessoa = new EntityPessoaToPessoa();
            $this->objPessoaToPessoa->setTipo($objRequest->get('tipo', NULL));
            $this->objPessoaToPessoa->setPessoa($this->objPessoa);
            $this->objPessoaToPessoa->setRelacao($this->objPessoaRelacao);
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
                    'idPessoa' => new Assert\Optional( [
                            $objRange
                        ]
                    ),
                    'idRelacao' => new Assert\Required( [
                            $objNotNull,
                            $objNotBlank,
                            $objRange
                        ]
                    )
                ]
            ]
        );
        
        $data = [
            'idPessoa'  => $objRequest->get('idPessoa', NULL),
            'idRelacao' => $objRequest->get('idRelacao', NULL),
            'tipo'      => $objRequest->get('tipo', NULL)
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
        
        if(!($this->objPessoa instanceof EntityPessoa)){
            $this->objPessoa = $this->objEntityManager->getRepository('App\Entity\Pessoas\Pessoa')->find($objRequest->get('idPessoa', NULL));
            if(!($this->objPessoa instanceof EntityPessoa)){
                throw new \RuntimeException('Pessoa não localizada.');
            }
        }
        
        $this->objPessoaRelacao = $this->objEntityManager->getRepository('App\Entity\Pessoas\Pessoa')->find($objRequest->get('idRelacao', NULL));
        if(!($this->objPessoaRelacao instanceof EntityPessoa)){
            throw new \RuntimeException('Relação não localizada.');
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
    public function getPessoa()
    {
        return $this->objPessoa;
    }
    
    /**
     * @return \App\Entity\Pessoas\Pessoa
     */
    public function getPessoaRelacao()
    {
        return $this->objPessoaRelacao;
    }
    
    /**
     * @param \App\Entity\Pessoas\PessoaToPessoa $objPessoaToPessoa
     */
    public function setPessoaToPessoa(\App\Entity\Pessoas\PessoaToPessoa $objPessoaToPessoa)
    {
        $this->objPessoaToPessoa = $objPessoaToPessoa;
    }
    
    /**
     * @param \App\Entity\Pessoas\Pessoa $objPessoa
     */
    public function setPessoa(\App\Entity\Pessoas\Pessoa $objPessoa)
    {
        $this->objPessoa = $objPessoa;
    }
    
    /**
     * @param \App\Entity\Pessoas\Pessoa $objPessoaRelacao
     */
    public function setRelacao(\App\Entity\Pessoas\Pessoa $objPessoaRelacao)
    {
        $this->objPessoaRelacao = $objPessoaRelacao;
    }
    
    public function save()
    {
        $this->objEntityManager->persist($this->objPessoaToPessoa);
        $this->objEntityManager->flush();
        return $this->objPessoaToPessoa;
    }
}
