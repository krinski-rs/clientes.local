<?php
namespace App\Service\Pessoas\Pessoa;

use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\Validator\Constraints as Assert;
use Symfony\Component\Validator\Validation;
use Doctrine\ORM\EntityManager;
use App\DBAL\Type\Enum\Vogel\NacionalidadePessoaType;
use App\DBAL\Type\Enum\Vogel\TipoPessoaType;
use App\Entity\Pessoas\Pessoa;
use App\Service\Pessoas\Nome\Create as CreateNome;
use App\Service\Pessoas\Endereco\Create as CreateEndereco;
use App\Service\Pessoas\Documento\Create as CreateDocumento;
use App\Service\Pessoas\PessoaToPessoa\Create as CreateRelacionamento;
use Monolog\Logger;

class Create
{
    private $objEntityManager   = NULL;
    private $objPessoa    = NULL;
    private $objLogger    = NULL;
    
    public function __construct(EntityManager $objEntityManager, Logger $objLogger)
    {
        $this->objEntityManager = $objEntityManager;
        $this->objLogger = $objLogger;
    }
    
    private function createNomes(Request $objRequest)
    {
        try {
            $arrayNomes = $objRequest->get('nomes', NULL);
            
            $objCreateNome = new CreateNome($this->objEntityManager);
            $objCreateNome->setPessoa($this->objPessoa);
            
            reset($arrayNomes);
            while($nomes = current($arrayNomes)){
                $objCreateNome->create(new Request([], [], $nomes));
                $this->objPessoa->addNome($objCreateNome->getNome());
                next($arrayNomes);
            }
            if($this->objPessoa->getNomes()->count() != count($arrayNomes)){
                throw new \RuntimeException('Erro ao inserir os nomes.');
            }
        } catch (\RuntimeException $e){
            throw $e;
        } catch (\Exception $e){
            throw $e;
        }
    }
    
    private function createEnderecos(Request $objRequest)
    {
        try {
            $arrayEnderecos = $objRequest->get('enderecos', NULL);
            
            $objCreateEndereco = new CreateEndereco($this->objEntityManager, $this->objLogger);
            $objCreateEndereco->setPessoa($this->objPessoa);
            
            reset($arrayEnderecos);
            while($enderecos = current($arrayEnderecos)){
                $objCreateEndereco->create(new Request([], [], $enderecos));
                $this->objPessoa->addEndereco($objCreateEndereco->getEndereco());
                next($arrayEnderecos);
            }
            
            if($this->objPessoa->getEnderecos()->count() != count($arrayEnderecos)){
                throw new \RuntimeException('Erro ao inserir os endereços.');
            }
            
        } catch (\RuntimeException $e){
            throw $e;
        } catch (\Exception $e){
            throw $e;
        }
    }
    
    private function createDocumentos(Request $objRequest)
    {
        try {
            $arrayDocumentos = $objRequest->get('documentos', NULL);
            
            $objCreateDocumento = new CreateDocumento($this->objEntityManager);
            $objCreateDocumento->setPessoa($this->objPessoa);
            
            reset($arrayDocumentos);
            while($documentos = current($arrayDocumentos)){
                $objCreateDocumento->create(new Request([], [], $documentos));
                $this->objPessoa->addDocumento($objCreateDocumento->getDocumento());
                next($arrayDocumentos);
            }
            
            if($this->objPessoa->getDocumentos()->count() != count($arrayDocumentos)){
                throw new \RuntimeException('Erro ao inserir os documentos.');
            }
            
        } catch (\RuntimeException $e){
            throw $e;
        } catch (\Exception $e){
            throw $e;
        }
    }
    
    private function createRelacionamento(Request $objRequest)
    {
        try {
            $arrayRelacionamentos = $objRequest->get('relacionamentos', NULL);
            if(count($arrayRelacionamentos)){
                $objCreateRelacionamento = new CreateRelacionamento($this->objEntityManager);
                $objCreateRelacionamento->setPessoa($this->objPessoa);
                
                reset($arrayRelacionamentos);
                while($relacionamento = current($arrayRelacionamentos)){
                    $objCreateRelacionamento->create(new Request([], [], $relacionamento));
                    $this->objPessoa->addRelacao($objCreateRelacionamento->getPessoaToPessoa());
                    next($arrayRelacionamentos);
                }
                
                if($this->objPessoa->getRelacao()->count() != count($arrayRelacionamentos)){
                    throw new \RuntimeException('Erro ao inserir os relacionamentos.');
                }
            }
            
        } catch (\RuntimeException $e){
            throw $e;
        } catch (\Exception $e){
            throw $e;
        }
    }
    
    public function create(Request $objRequest)
    {
        try {
            $this->validate($objRequest);
                        
            $this->objPessoa = new Pessoa();
            $this->objPessoa->setAtivo($objRequest->get('ativo', NULL));
            $this->objPessoa->setDataAniversario(\DateTime::createFromFormat('Y-m-d H:i:s', $objRequest->get('dataAniversario', NULL)));
            $this->objPessoa->setDataCadastro(new \DateTime());
            $this->objPessoa->setNacionalidade($objRequest->get('nacionalidade', NULL));
            $this->objPessoa->setTipo($objRequest->get('tipo', NULL));
            $this->createNomes($objRequest);
            $this->createDocumentos($objRequest);
            $this->createEnderecos($objRequest);
//             $this->createRelacionamento($objRequest);
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
        
        $objLength = new Assert\Length(
            [
                'min' => 2,
                'max' => 255,
                'minMessage' => 'O campo deve ter pelo menos {{ limit }} caracteres.',
                'maxMessage' => 'O campo não pode ser maior do que {{ limit }} caracteres.'
            ]
        );

        $objChoiceNacionalidade = new Assert\Choice(
            [
                'choices' => NacionalidadePessoaType::getChoices(),
                'message' => 'Selecione uma nacionalidade válida.'
            ]
        );
        
        $objChoiceTipo = new Assert\Choice(
            [
                'choices' => TipoPessoaType::getChoices(),
                'message' => 'Selecione um tipo de pessoa válido.'
            ]
        );
        
        $objType = new Assert\Type(
            [
                'type' => 'bool',
                'message' => 'O valor \'{{ value }}\' não é válido \'{{ type }}\'.'
            ]
        );
        
        $objDate = new Assert\DateTime(
            [
                'message' => 'O valor \'{{ value }}\' não é uma data válida.'
            ]
        );
        
        $objLength = new Assert\Length(
            [
                'min'           => 3,
                'max'           => 255,
                'minMessage'    => 'Este valor é muito curto. Deve ter {{ limit }} caracteres ou mais.',
                'maxMessage'    => 'Este valor é muito longo. Deve ter {{ limit }} caracteres ou menos.'
            ]
        );
        
        $objCount = new Assert\Count(
            [
                'min'           => 1,
                'max'           => 2,
                'minMessage'    => 'Esta coleção deve conter elementos de {{ limit }} ou mais.',
                'maxMessage'    => 'Esta coleção deve conter elementos de {{ limit }} ou menos.'
            ]
        );
        
        $objRecursiveValidator = Validation::createValidatorBuilder()->getValidator();
        
        $objCollection = new Assert\Collection(
            [
                'fields' => [
                    'nacionalidade' => new Assert\Required( [
                            $objNotNull,
                            $objNotBlank,
                            $objChoiceNacionalidade
                        ]
                    ),
                    'tipo' => new Assert\Required( [
                            $objNotNull,
                            $objNotBlank,
                            $objChoiceTipo
                        ]
                    ),
                    'dataAniversario' => new Assert\Required( [
                            $objNotNull,
                            $objNotBlank,
                            $objDate
                        ]
                    ),
                    'ativo' => new Assert\Required( [
                            $objNotNull,
                            $objType
                        ]
                    ),
                    'nomes' => new Assert\Required( [
                            $objNotNull,
                            $objNotBlank,
                            $objCount
                        ]
                    ),
                    'enderecos' => new Assert\Required( [
                            $objNotNull,
                            $objNotBlank,
                            $objCount
                        ]
                    ),
                    'documentos' => new Assert\Required( [
                            $objNotNull,
                            $objNotBlank,
                            $objCount
                        ]
                    )
                ]
            ]
        );
        $data = [
            'tipo'                  => $objRequest->get('tipo', NULL),
            'nacionalidade'         => $objRequest->get('nacionalidade', NULL),
            'dataAniversario'       => $objRequest->get('dataAniversario', NULL),
            'ativo'                 => $objRequest->get('ativo', NULL),
            'nomes'                 => $objRequest->get('nomes', NULL),
            'enderecos'             => $objRequest->get('enderecos', NULL),
            'documentos'            => $objRequest->get('documentos', NULL)
        ];
        
        $this->objLogger->error('opa', $objRequest->attributes->all());
        
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
    }
    
    public function save()
    {
        $this->objEntityManager->persist($this->objPessoa);
        $this->objEntityManager->flush();
        return $this->objPessoa;
    }
}

