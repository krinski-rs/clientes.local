<?php
namespace App\Service\Pessoas\Documento;

use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\Validator\Constraints as Assert;
use Symfony\Component\Validator\Validation;
use Doctrine\ORM\EntityManager;
use App\Entity\Pessoas\Pessoa;
use App\Entity\Pessoas\Endereco;
use App\DBAL\Type\Enum\Vogel\TipoEnderecoPessoaType;
use App\DBAL\PHP\Spatial\Geometry\Point;
use App\Entity\Pessoas\Documento;
use App\DBAL\Type\Enum\Vogel\TipoDocumentoType;

class Create
{
    private $objEntityManager   = NULL;
    private $objDocumento       = NULL;
    private $objPessoa          = NULL;
    
    public function __construct(EntityManager $objEntityManager)
    {
        $this->objEntityManager = $objEntityManager;
    }
    
    public function create(Request $objRequest)
    {
        try {
            
            $this->validate($objRequest);
            $this->objDocumento = new Documento();
            $this->objDocumento->setDataCadastro(new \DateTime());
            $this->objDocumento->setPessoa($this->objPessoa);
            $this->objDocumento->setTipo($objRequest->get('tipo', NULL));
            $this->objDocumento->setValor(trim($objRequest->get('valor', NULL)));
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
            'choices' => TipoDocumentoType::getChoices(),
            'message' => 'Selecione um tipo de documento válido.'
        ] );
        
        $objLength = new Assert\Length( [
            'min'           => 5,
            'max'           => 255,
            'minMessage'    => 'Este valor é muito curto. Deve ter {{ limit }} caracteres ou mais.',
            'maxMessage'    => 'Este valor é muito longo. Deve ter {{ limit }} caracteres ou menos.'
        ] );
        
        $objRange = new Assert\Range( [
            'min'               => 1,
            'max'               => 9999999,
            'minMessage'        => 'Este valor deve ser de {{ limit }} ou mais.',
            'maxMessage'        => 'Este valor deve ser de {{ limit }} ou menos.',
            'invalidMessage'    => 'Este valor deve ser um número válido.'
        ] );
        
        $objRecursiveValidator = Validation::createValidatorBuilder()->getValidator();
        
        $objCollection = new Assert\Collection(
            [
                'fields' => [
                    'valor' => new Assert\Required( [
                            $objNotNull,
                            $objNotBlank,
                            $objLength
                        ]
                    ),
                    'tipo' => new Assert\Required( [
                            $objNotNull,
                            $objNotBlank,
                            $objChoiceTipo
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
            'valor'     => trim($objRequest->get('valor', NULL)),
            'idPessoa'  => $objRequest->get('idPessoa', NULL),
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
     * @return \App\Entity\Pessoas\Documento
     */
    public function getDocumento()
    {
        return $this->objDocumento;
    }
    
    /**
     * @param \App\Entity\Pessoas\Documento $objEndereco
     */
    public function setDocumento(Documento $objEndereco)
    {
        $this->objDocumento = $objDocumento;
    }
    
    public function save()
    {
        $this->objEntityManager->persist($this->objDocumento);
        $this->objEntityManager->flush();
        return $this->objDocumento;
    }
}
