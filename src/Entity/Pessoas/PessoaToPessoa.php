<?php

namespace App\Entity\Pessoas;

/**
 * PessoaToPessoa
 */
class PessoaToPessoa
{
    /**
     * @var pessoas.tipo_relacionamento_pessoa
     */
    private $tipo;

    /**
     * @var \App\Entity\Pessoas\Pessoa
     */
    private $pessoaOrigem;

    /**
     * @var \App\Entity\Pessoas\Pessoa
     */
    private $pessoaDestino;


    /**
     * Set tipo.
     *
     * @param pessoas.tipo_relacionamento_pessoa $tipo
     *
     * @return PessoaToPessoa
     */
    public function setTipo($tipo)
    {
        $this->tipo = $tipo;

        return $this;
    }

    /**
     * Get tipo.
     *
     * @return pessoas.tipo_relacionamento_pessoa
     */
    public function getTipo()
    {
        return $this->tipo;
    }

    /**
     * Set pessoaOrigem.
     *
     * @param \App\Entity\Pessoas\Pessoa $pessoaOrigem
     *
     * @return PessoaToPessoa
     */
    public function setPessoaOrigem(\App\Entity\Pessoas\Pessoa $pessoaOrigem)
    {
        $this->pessoaOrigem = $pessoaOrigem;

        return $this;
    }

    /**
     * Get pessoaOrigem.
     *
     * @return \App\Entity\Pessoas\Pessoa
     */
    public function getPessoaOrigem()
    {
        return $this->pessoaOrigem;
    }

    /**
     * Set pessoaDestino.
     *
     * @param \App\Entity\Pessoas\Pessoa $pessoaDestino
     *
     * @return PessoaToPessoa
     */
    public function setPessoaDestino(\App\Entity\Pessoas\Pessoa $pessoaDestino)
    {
        $this->pessoaDestino = $pessoaDestino;

        return $this;
    }

    /**
     * Get pessoaDestino.
     *
     * @return \App\Entity\Pessoas\Pessoa
     */
    public function getPessoaDestino()
    {
        return $this->pessoaDestino;
    }
}
