<?php
namespace App\Service\Pessoas\Endereco;

use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\Validator\Constraints as Assert;
use Symfony\Component\Validator\Validation;
use Doctrine\ORM\EntityManager;
use App\Entity\Pessoas\Pessoa;
use App\Entity\Pessoas\Endereco;
use App\DBAL\Type\Enum\Vogel\TipoEnderecoPessoaType;
use App\DBAL\PHP\Spatial\Geometry\Point;
use Monolog\Logger;

class Create
{
    private $objEntityManager   = NULL;
    private $objEndereco    = NULL;
    private $objPessoa  = NULL;
    private $objLogger  = NULL;
    
    public function __construct(EntityManager $objEntityManager, Logger $objLogger)
    {
        $this->objEntityManager = $objEntityManager;
        $this->objLogger = $objLogger;
    }
    
    public function create(Request $objRequest)
    {
        try {
            $this->objLogger->error("PAIS", [trim($objRequest->get('pais', NULL))]);
            $this->validate($objRequest);
            $this->objEndereco = new Endereco();
            $this->objEndereco->setBairro(trim($objRequest->get('bairro', NULL)));
            $this->objEndereco->setCep(trim($objRequest->get('cep', NULL)));
            $this->objEndereco->setCidade(trim($objRequest->get('cidade', NULL)));
            $this->objEndereco->setComplemento($objRequest->get('complemento', NULL));
            $this->objEndereco->setEstado(trim($objRequest->get('estado', NULL)));
            $this->objEndereco->setPessoa($this->objPessoa);
            if($objRequest->get('localizacao', NULL)){
                $localizacao = $objRequest->get('localizacao', NULL);
                $objPoint = new Point($localizacao['latitude'], $localizacao['longitude']);
                $this->objEndereco->setLocalizacao($objPoint);
            }
            $this->objEndereco->setLogradouro(trim($objRequest->get('logradouro', NULL)));
            $this->objEndereco->setNumero(trim($objRequest->get('numero', NULL)));
            $this->objEndereco->setPais(trim($objRequest->get('pais', NULL)));
            $this->objEndereco->setTipo(trim($objRequest->get('tipo', NULL)));
            $this->objEndereco->setUf(trim($objRequest->get('uf', NULL)));
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
            'choices' => TipoEnderecoPessoaType::getChoices(),
            'message' => 'Selecione um tipo de endereço válido.'
        ] );
        
        $objLength = new Assert\Length( [
            'min'           => 1,
            'max'           => 255,
            'minMessage'    => 'Este valor é muito curto. Deve ter {{ limit }} caracteres ou mais.',
            'maxMessage'    => 'Este valor é muito longo. Deve ter {{ limit }} caracteres ou menos.'
        ] );
        
        $objLengthCep = new Assert\Length( [
            'min'           => 8,
            'max'           => 8,
            'minMessage'    => 'Este valor é muito curto. Deve ter {{ limit }} caracteres ou mais.',
            'maxMessage'    => 'Este valor é muito longo. Deve ter {{ limit }} caracteres ou menos.',
            'exactMessage'    => 'Este valor deve ter exatamente {{ limit }} caracteres.'
        ] );
        
        $objRange = new Assert\Range( [
            'min'               => 1,
            'max'               => 999999999,
            'minMessage'        => 'Este valor deve ser de {{ limit }} ou mais.',
            'maxMessage'        => 'Este valor deve ser de {{ limit }} ou menos.',
            'invalidMessage'    => 'Este valor deve ser um número válido.'
        ] );
        
        $objRangeLatitude = new Assert\Range( [
            'min'               => -90,
            'max'               => 90,
            'minMessage'        => 'Este valor deve ser de {{ limit }} ou mais.',
            'maxMessage'        => 'Este valor deve ser de {{ limit }} ou menos.',
            'invalidMessage'    => 'Este valor deve ser um número válido.'
        ] );
        
        $objRangeLongitude = new Assert\Range( [
            'min'               => -180,
            'max'               => 180,
            'minMessage'        => 'Este valor deve ser de {{ limit }} ou mais.',
            'maxMessage'        => 'Este valor deve ser de {{ limit }} ou menos.',
            'invalidMessage'    => 'Este valor deve ser um número válido.'
        ] );
        
        $objRecursiveValidator = Validation::createValidatorBuilder()->getValidator();
        
        $objCollection = new Assert\Collection(
            [
                'fields' => [
                    'bairro' => new Assert\Required( [
                            $objNotNull,
                            $objNotBlank,
                            $objLength
                        ]
                    ),
                    'cep' => new Assert\Required( [
                            $objNotNull,
                            $objNotBlank,
                            $objLengthCep
                        ]
                    ),
                    'cidade' => new Assert\Required( [
                            $objNotNull,
                            $objNotBlank,
                            $objLength
                        ]
                    ),
                    'complemento' => new Assert\Optional( [
                            $objLength
                        ]
                    ),
                    'estado' => new Assert\Optional( [
                            $objNotNull,
                            $objNotBlank,
                            $objLength
                        ]
                    ),
                    'idPessoa' => new Assert\Optional( [
                            $objRange
                        ]
                    ),
                    'localizacao' => new Assert\Optional( [
                        new Assert\Collection( [
                            'latitude' => new Assert\Required( [
                                $objRangeLatitude
                            ] ),
                            'longitude' => new Assert\Required( [
                                $objRangeLongitude
                            ] ),
                        ] )
                    ]
                    ),
                    'logradouro' => new Assert\Optional( [
                            $objNotNull,
                            $objNotBlank,
                            $objLength
                        ]
                    ),
                    'numero' => new Assert\Optional( [
                            $objNotNull,
                            $objNotBlank,
                            $objLength
                        ]
                    ),
                    'pais' => new Assert\Optional( [
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
                    'uf' => new Assert\Required( [
                            $objNotNull,
                            $objNotBlank,
                            $objLength
                        ]
                    )
                ]
            ]
        );
        
        $data = [
            'bairro'        => trim($objRequest->get('bairro', NULL)),
            'cep'           => trim($objRequest->get('cep', NULL)),
            'cidade'        => trim($objRequest->get('cidade', NULL)),
            'complemento'   => $objRequest->get('complemento', NULL),
            'estado'        => trim($objRequest->get('estado', NULL)),
            'idPessoa'      => $objRequest->get('idPessoa', NULL),
            'localizacao'   => $objRequest->get('localizacao', NULL),
            'logradouro'    => trim($objRequest->get('logradouro', NULL)),
            'numero'        => trim($objRequest->get('numero', NULL)),
            'pais'          => trim($objRequest->get('pais', NULL)),
            'tipo'          => trim($objRequest->get('tipo', NULL)),
            'uf'            => trim($objRequest->get('uf', NULL))
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
     * @return \App\Entity\Pessoas\Endereco
     */
    public function getEndereco()
    {
        return $this->objEndereco;
    }
    
    /**
     * @param \App\Entity\Pessoas\Endereco $objEndereco
     */
    public function setEndereco(Endereco $objEndereco)
    {
        $this->objEndereco = $objEndereco;
    }
    
    public function save()
    {
        $this->objEntityManager->persist($this->objEndereco);
        $this->objEntityManager->flush();
        return $this->objEndereco;
    }
}
