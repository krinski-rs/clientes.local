<?php
namespace App\DBAL\Type\Enum\Vogel;

use App\DBAL\Type\Enum\AbstractEnumType;

final class TipoRelacionamentoPessoaType extends AbstractEnumType
{
    const AMIGO                     = 'AMIGO';
    const PARENTE                   = 'PARENTE';
    const CONJUGE                   = 'CONJUGE';
    const FILHO                     = 'FILHO';
    const SOCIO                     = 'SÓCIO';
    const COLABORADOR               = 'COLABORADOR';
    const CONTATO_TECNICO           = 'CONTATO TÉCNICO';
    const CONTATATO_FINANCEIRO      = 'CONTATATO FINANCEIRO';
    const CONTATO_EMERGENCIAL       = 'CONTATO EMERGENCIAL';
    const CONTATO_ADMINISTRATIVO    = 'CONTATO ADMINISTRATIVO';
    const SECRETARIO                = 'SECRETÁRIO';
    const MATRIZ                    = 'MATRIZ';
    const FILIAL                    = 'FILIAL';
    const FRANQUIA                  = 'FRANQUIA';
    const TERCEIRIZADA              = 'TERCEIRIZADA';
    const PAI                       = 'PAI';
    const MAE                       = 'MÃE';
    const IRMAO                     = 'IRMÃO';
    
    /**
     * {@inheritdoc}
     */
    protected $name = 'pessoas.tipo_relacionamento_pessoa';
    
    /**
     * {@inheritdoc}
     */
    protected static $choices = [
        self::AMIGO                     => 1,
        self::PARENTE                   => 2,
        self::CONJUGE                   => 3,
        self::FILHO                     => 4,
        self::SOCIO                     => 5,
        self::COLABORADOR               => 6,
        self::CONTATO_TECNICO           => 7,
        self::CONTATATO_FINANCEIRO      => 8,
        self::CONTATO_EMERGENCIAL       => 9,
        self::CONTATO_ADMINISTRATIVO    => 10,
        self::SECRETARIO                => 11,
        self::MATRIZ                    => 12,
        self::FILIAL                    => 13,
        self::FRANQUIA                  => 14,
        self::TERCEIRIZADA              => 15,
        self::PAI                       => 16,
        self::MAE                       => 17,
        self::IRMAO                     => 18
    ];
}

