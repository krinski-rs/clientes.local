<?php
namespace App\DBAL\Type\Enum\Vogel;

use App\DBAL\Type\Enum\AbstractEnumType;

final class TipoNomePessoaType extends AbstractEnumType
{
    const RAZAO_SOCIAL  = 'RAZÃO SOCIAL';
    const NOME_FANTASIA = 'NOME FANTASIA';
    const NOME          = 'NOME';
    const USERNAME      = 'USERNAME';
    const NICKNAME      = 'NICKNAME';
    
    /**
     * {@inheritdoc}
     */
    protected $name = 'pessoas.tipo_nome_pessoa';
    
    /**
     * {@inheritdoc}
     */
    protected static $choices = [
        self::RAZAO_SOCIAL  => 1,
        self::NOME_FANTASIA => 2,
        self::NOME          => 3,
        self::USERNAME      => 4,
        self::NICKNAME      => 5
    ];
}

