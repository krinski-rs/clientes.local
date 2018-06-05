<?php
namespace App\Strategy;

use Symfony\Component\HttpFoundation\Request;
use App\Entity\Pessoas\Pessoa;

interface StrategyPessoaInterface
{
    public function create(Request $objRequest):Pessoa;
}

