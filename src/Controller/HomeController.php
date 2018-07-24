<?php
namespace App\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Request;
use App\Service\Pessoas\Pessoa as PessoaService;
use Symfony\Component\Serializer\Encoder\XmlEncoder;
use Symfony\Component\Serializer\Encoder\JsonEncoder;
use Symfony\Component\Serializer\Normalizer\ObjectNormalizer;
use Symfony\Component\Serializer\Serializer;
use App\Entity\Pessoas\Pessoa;

class HomeController extends Controller
{
    public function login(Request $objRequest)
    {
        try {            
            return $this->render(
                'login.html.twig',
                [
                    'title' => 'R&K'
                ]
            );
        } catch (\RuntimeException $e) {
            return new JsonResponse(['mensagem'=>$e->getMessage()], Response::HTTP_PRECONDITION_FAILED);
        } catch (\Exception $e) {
            return new JsonResponse(['mensagem'=>$e->getMessage()], Response::HTTP_INTERNAL_SERVER_ERROR);
        }
    }
    
    public function auth(Request $objRequest)
    {
        try {
            $objSSOClient = $this->get('sso_client');
            return $objSSOClient->login();
        } catch (\RuntimeException $e) {
            return new JsonResponse(['mensagem'=>$e->getMessage()], Response::HTTP_PRECONDITION_FAILED);
        } catch (\Exception $e) {
            return new JsonResponse(['mensagem'=>$e->getMessage()], Response::HTTP_INTERNAL_SERVER_ERROR);
        }
        
    }
    
    public function logout()
    {
        try {
            $objSSOClient = $this->get('sso_client');
            return $objSSOClient->logout();
        } catch (\RuntimeException $e) {
            return new JsonResponse(['mensagem'=>$e->getMessage()], Response::HTTP_PRECONDITION_FAILED);
        } catch (\Exception $e) {
            return new JsonResponse(['mensagem'=>$e->getMessage()], Response::HTTP_INTERNAL_SERVER_ERROR);
        }
    }
    
    public function home(Request $objRequest)
    {
        try {
            return $this->render(
                'pessoa/site.html.twig',
                [
                    'title'     => 'R&K',
                    'top'       => [
                        'logo'  => '/img/logo.png'
                    ],
                    'menuTop'     => [
                        [
                            'labelClass'    => 'label-success',
                            'labelTotal'    => '3',
                            'icon'          => 'icon-envelope-alt',
                            'subMenus'       => [
                                'class' => 'dropdown-messages',
                                'menu'  => [
                                    [
                                        'href'          => '#',
                                        'desc'          => 'John Smith',
                                        'info'          => 'Today',
                                        'text'          => 'Lorem ipsum dolor sit amet, consectetur adipiscing.',
                                        'label'         => 'Important',
                                        'labelClass'    => 'label-primary'
                                    ],
                                    [
                                        'href'          => '#',
                                        'desc'          => 'Raphel Jonson',
                                        'info'          => 'Yesterday',
                                        'text'          => 'Lorem ipsum dolor sit amet, consectetur adipiscing.',
                                        'label'         => 'Moderate',
                                        'labelClass'    => 'label-success'
                                    ],
                                    [
                                        'href'          => '#',
                                        'desc'          => 'Chi Ley Suk',
                                        'info'          => '26 Jan 2014',
                                        'text'          => 'Lorem ipsum dolor sit amet, consectetur adipiscing.',
                                        'label'         => 'Low',
                                        'labelClass'    => 'label-danger'
                                    ]
                                ]
                            ]
                        ],
                        [
                            'labelClass'    => 'label-danger',
                            'labelTotal'    => '4',
                            'icon'          => 'icon-tasks',
                            'subMenus'       => [
                                'class' => 'dropdown-tasks',
                                'menu'  => [
                                    [
                                        'href'          => '#',
                                        'desc'          => 'Profile',
                                        'info'          => '40% Complete',
                                        'labelClass'    => 'progress-bar-success',
                                        'label'         => '40% Complete (success)',
                                    ],
                                    [
                                        'href'          => '#',
                                        'desc'          => 'Pending Tasks',
                                        'info'          => '20% Complete',
                                        'labelClass'    => 'progress-bar-info',
                                        'label'         => '20% Complete',
                                    ],
                                    [
                                        'href'          => '#',
                                        'desc'          => 'Work Completed',
                                        'info'          => '60% Complete',
                                        'labelClass'    => 'progress-bar-warning',
                                        'label'         => '60% Complete (warning)',
                                    ],
                                    [
                                        'href'          => '#',
                                        'desc'          => 'Summary',
                                        'info'          => '80% Complete',
                                        'labelClass'    => 'progress-bar-danger',
                                        'label'         => '80% Complete (danger)',
                                    ]
                                ]
                            ]
                        ],
                        [
                            'labelClass'    => 'label-info',
                            'labelTotal'    => '5',
                            'class'         => 'chat-panel',
                            'icon'          => 'icon-comments',
                            'subMenus'       => [
                                'class' => 'dropdown-alerts',
                                'menu'  => [
                                    [
                                        'href'  => '#',
                                        'desc'  => 'New Comment',
                                        'info'  => '4 minutes ago',
                                        'icon'  => 'icon-comment',
                                    ],
                                    [
                                        'href'  => '#',
                                        'desc'  => '3 New Follower',
                                        'info'  => '9 minutes ago',
                                        'icon'  => 'icon-twitter info',
                                    ],
                                    [
                                        'href'  => '#',
                                        'desc'  => 'Message Sent',
                                        'info'  => '20 minutes ago',
                                        'icon'  => 'icon-envelope',
                                    ],
                                    [
                                        'href'  => '#',
                                        'desc'  => 'New Task',
                                        'info'  => '1 Hour ago',
                                        'icon'  => 'icon-tasks',
                                    ],
                                    [
                                        'href'  => '#',
                                        'desc'  => 'Server Rebooted',
                                        'info'  => '2 Hour ago',
                                        'icon'  => 'icon-upload',
                                    ]
                                ]
                            ]
                        ],
                        [
                            'icon'          => 'icon-user',
                            'subMenus'       => [
                                'class' => 'dropdown-user',
                                'menu'  => [
                                    [
                                        'href'  => '#',
                                        'info'  => 'User Profile',
                                        'icon'  => 'icon-user',
                                    ],
                                    [
                                        'href'  => '#',
                                        'info'  => 'Settings',
                                        'icon'  => 'icon-gear',
                                    ],
                                    [
                                        'href'  => '/logout',
                                        'info'  => 'Logout',
                                        'icon'  => 'icon-signout',
                                    ]
                                ]
                            ]
                        ]
                    ],
                    'userInfo'  => [
                        'href'      => '#',
                        'img'       => '/img/user.gif',
                        'name'      => 'Reinaldo K.',
                        'class'     => 'btn-success',
                        'status'    => 'Online'
                    ],
                    'menu'      => [
                        [
                            'href'  => 'http://site.local.com/home',
                            'icon'  => 'icon-home',
                            'text'  => 'Home',
                            'class' => 'panel',
                            'menu'  => []
                        ],
                        [
                            'href'  => '#',
                            'icon'  => 'icon-user',
                            'text'  => 'Pessoa Física',
                            'total' => '0',
                            'class'  => 'panel pessoa_fisica',
                            'labelClass'  => 'label-default',
                            'menu'  => []
                        ],
                        [
                            'href'  => '#',
                            'icon'  => 'icon-legal',
                            'text'  => 'Pessoa Jurídica',
                            'class'  => 'panel',
                            'labelClass'  => 'label-success',
                            'total' => '0',
                            'menu'  => []
                        ],
                        [
                            'href'  => '#',
                            'icon'  => 'icon-usd',
                            'text'  => 'Cliente',
                            'class'  => 'panel',
                            'labelClass'  => 'label-info',
                            'total' => '0',
                            'menu'  => []
                        ],
                        [
                            'href'  => '#',
                            'icon'  => 'icon-credit-card',
                            'text'  => 'Fornecedores',
                            'class'  => 'panel',
                            'labelClass'  => 'label-danger',
                            'total' => '0',
                            'menu'  => []
                        ],
                        [
                            'href'  => '#',
                            'icon'  => 'icon-group',
                            'text'  => 'Pessoas',
                            'class'  => 'panel',
                            'labelClass'  => 'label-danger',
                            'total' => '0',
                            'menu'  => []
                        ]
                    ],
                    'content'   => [
                        'title' => 'Pessoas'
                    ],
                    'info'      => [
                        'list'          => [
                            [
                                'text'  => 'Visitor&nbsp;:',
                                'info'  => '23,000'
                            ],
                            [
                                'text'  => 'Users&nbsp;:',
                                'info'  => '53,000'
                            ],
                            [
                                'text'  => 'Registrations&nbsp;:',
                                'info'  => '3,000'
                            ]
                        ],
                        'buttons'       => [
                            [
                                'class' => 'btn-block',
                                'text'  => 'Help'
                            ],
                            [
                                'class' => 'btn-primary',
                                'text'  => 'Tickets'
                            ],
                            [
                                'class' => 'btn-info',
                                'text'  => 'New'
                            ],
                            [
                                'class' => 'btn-success',
                                'text'  => 'Users'
                            ],
                            [
                                'class' => 'btn-danger',
                                'text'  => 'Profit'
                            ],
                            [
                                'class' => 'btn-warning',
                                'text'  => 'Sales'
                            ],
                            [
                                'class' => 'btn-inverse',
                                'text'  => 'Stock'
                            ]
                        ],
                        'progress'   => [
                            [
                                'text'      => 'Profit',
                                'class'     => 'progress-bar-info',
                                'percent'   => '20'
                            ],
                            [
                                'text'      => 'Sales',
                                'class'     => 'progress-bar-success',
                                'percent'   => '40'
                            ],
                            [
                                'text'      => 'Pending',
                                'class'     => 'progress-bar-warning',
                                'percent'   => '60'
                            ],
                            [
                                'text'      => 'Summary',
                                'class'     => 'progress-bar-danger',
                                'percent'   => '80'
                            ]
                        ]
                    ],
                    'footer'    => '<p>&copy;&nbsp;Reinaldo Krinski&nbsp;2018&nbsp;</p>'
                ]
            );
        } catch (\RuntimeException $e) {
            return new JsonResponse(['mensagem'=>$e->getMessage()], Response::HTTP_PRECONDITION_FAILED);
        } catch (\Exception $e) {
            return new JsonResponse(['mensagem'=>$e->getMessage()], Response::HTTP_INTERNAL_SERVER_ERROR);
        }
    }
    
    public function listTable(Request $objRequest)
    {
        try {
            $objPessoasPessoa = $this->get('pessoas.pessoa');
            if(!$objPessoasPessoa instanceof PessoaService){
                return new JsonResponse(['message'=> 'Class "App\Service\Pessoas\Pessoa not found."'], Response::HTTP_INTERNAL_SERVER_ERROR);
            }
            
            $arrayPessoa = [];
            $encoders = array(new XmlEncoder(), new JsonEncoder());
            
            $objObjectNormalizer = new ObjectNormalizer();
            
            $objObjectNormalizer->setCircularReferenceHandler(function (Pessoa $objPessoa) {
                return $objPessoa->getId();
            });
                
            $callbackDateTime = function ($dateTime) {
                return $dateTime instanceof \DateTime
                ? $dateTime->format(\DateTime::ISO8601)
                : '';
            };
            
            $objObjectNormalizer->setCallbacks(array('dataCadastro' => $callbackDateTime, 'dataAniversario' => $callbackDateTime));
            $objObjectNormalizer->setCircularReferenceLimit(1);
            $normalizers = array($objObjectNormalizer);
            
            $objSerializer = new Serializer($normalizers, $encoders);
            $arrayPessoa['body'] = $objSerializer->normalize($objPessoasPessoa->list($objRequest), NULL, ['attributes' =>['id', 'nomes' => ['nome'], 'tipo', 'nacionalidade', 'ativo']]);
            $arrayPessoa['title'] = $objRequest->get('title', '');
            $arrayPessoa['id'] = 'chitos';
            $arrayPessoa['header'] = ['Código', 'Nome', 'Tipo', 'Nacionalidade', 'Status'];
//             echo '<pre>';
//             \Doctrine\Common\Util\Debug::dump($arrayPessoa,3);
//             exit();
            return $this->render(
                'base/content.html.twig',
                [
                    'content'   => [
                        'title' => $objRequest->get('title', ''),
                        'table' => $arrayPessoa,
                    ]
                ]
            );
        } catch (\RuntimeException $e) {
            return new JsonResponse(['mensagem'=>$e->getMessage()], Response::HTTP_PRECONDITION_FAILED);
        } catch (\Exception $e) {
            return new JsonResponse(['mensagem'=>$e->getMessage()], Response::HTTP_INTERNAL_SERVER_ERROR);
        }
    }
}

