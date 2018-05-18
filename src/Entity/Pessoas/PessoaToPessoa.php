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
    private $pessoa;

    /**
     * @var \App\Entity\Pessoas\Pessoa
     */
    private $relacao;


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
     * Set pessoa.
     *
     * @param \App\Entity\Pessoas\Pessoa $pessoa
     *
     * @return PessoaToPessoa
     */
    public function setPessoa(\App\Entity\Pessoas\Pessoa $pessoa)
    {
        $this->pessoa = $pessoa;

        return $this;
    }

    /**
     * Get pessoa.
     *
     * @return \App\Entity\Pessoas\Pessoa
     */
    public function getPessoa()
    {
        return $this->pessoa;
    }

    /**
     * Set relacao.
     *
     * @param \App\Entity\Pessoas\Pessoa $relacao
     *
     * @return PessoaToPessoa
     */
    public function setRelacao(\App\Entity\Pessoas\Pessoa $relacao)
    {
        $this->relacao = $relacao;

        return $this;
    }

    /**
     * Get relacao.
     *
     * @return \App\Entity\Pessoas\Pessoa
     */
    public function getRelacao()
    {
        return $this->relacao;
    }
}
