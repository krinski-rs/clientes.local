<?php
namespace App\DBAL\Type\Enum\Vogel;

use App\DBAL\Type\Enum\AbstractEnumType;

final class TipoPessoaType extends AbstractEnumType
{
    const JURIDICA  = 'JURÍDICA';
    const FISICA    = 'FÍSICA';
    const USUARIO   = 'USUÁRIO';
    
    /**
     * {@inheritdoc}
     */
    protected $name = 'pessoas.tipo_pessoa';
    
    /**
     * {@inheritdoc}
     */
    protected static $choices = [
        self::JURIDICA  => 1,
        self::FISICA    => 2,
        self::USUARIO   => 3
    ];
}

