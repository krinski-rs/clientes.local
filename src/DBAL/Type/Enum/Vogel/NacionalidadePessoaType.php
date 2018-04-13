<?php
namespace App\DBAL\Type\Enum\Vogel;

use App\DBAL\Type\Enum\AbstractEnumType;

final class NacionalidadePessoaType extends AbstractEnumType
{
    const BRASILEIRA    = 'BRASILEIRA';
    const ESTRANGEIRA   = 'ESTRANGEIRA';
    
    /**
     * {@inheritdoc}
     */
    protected $name = 'pessoas.nacionalidade_pessoa';
    
    /**
     * {@inheritdoc}
     */
    protected static $choices = [
        self::BRASILEIRA    => 1,
        self::ESTRANGEIRA   => 2
    ];
}

