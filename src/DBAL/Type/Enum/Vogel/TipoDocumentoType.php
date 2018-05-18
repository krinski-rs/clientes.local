<?php
namespace App\DBAL\Type\Enum\Vogel;

use App\DBAL\Type\Enum\AbstractEnumType;

final class TipoDocumentoType extends AbstractEnumType
{
    const RG                    = 'RG';
    const CPF                   = 'CPF';
    const CNPJ                  = 'CNPJ';
    const INSCRIAO_MUNICIPAL    = 'INSCRIÇÃO MUNICIPAL';
    const INSCRICOO_ESTADUAL    = 'INSCRIÇÃO ESTADUAL';
    const CERTIDAO_NASCIMENTO   = 'CERTIDÃO DE NASCIMENTO';
    const CARTEIRA_HABILITACAO  = 'CARTEIRA DE HABILITAÇÃO';
    
    /**
     * {@inheritdoc}
     */
    protected $name = 'pessoas.tipo_documento';
    
    /**
     * {@inheritdoc}
     */
    protected static $choices = [
        self::RG  => 1,
        self::CPF    => 2,
        self::CNPJ   => 3,
        self::INSCRIAO_MUNICIPAL  => 4,
        self::INSCRICOO_ESTADUAL    => 5,
        self::CERTIDAO_NASCIMENTO   => 6,
        self::CARTEIRA_HABILITACAO  => 7
    ];
}
