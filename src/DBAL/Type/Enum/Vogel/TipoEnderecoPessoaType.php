<?php
namespace App\DBAL\Type\Enum\Vogel;

use App\DBAL\Type\Enum\AbstractEnumType;

final class TipoEnderecoPessoaType extends AbstractEnumType
{
    const COMERCIAL     = 'COMERCIAL';
    const RESIDENCIAL   = 'RESIDENCIAL';
    const COBRANCA      = 'COBRANÇA';
    
    /**
     * {@inheritdoc}
     */
    protected $name = 'pessoas.tipo_endereco_pessoa';
    
    /**
     * {@inheritdoc}
     */
    protected static $choices = [
        self::COMERCIAL     => 1,
        self::RESIDENCIAL   => 2,
        self::COBRANCA      => 3
    ];
}

