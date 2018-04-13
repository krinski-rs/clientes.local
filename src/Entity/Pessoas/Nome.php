<?php

namespace App\Entity\Pessoas;

/**
 * Nome
 */
class Nome
{
    /**
     * @var int
     */
    private $id;

    /**
     * @var pessoas.tipo_nome_pessoa
     */
    private $tipo;

    /**
     * @var string
     */
    private $nome;

    /**
     * @var \App\Entity\Pessoas\Pessoa
     */
    private $idPessoa;


    /**
     * Get id.
     *
     * @return int
     */
    public function getId()
    {
        return $this->id;
    }

    /**
     * Set tipo.
     *
     * @param pessoas.tipo_nome_pessoa $tipo
     *
     * @return Nome
     */
    public function setTipo($tipo)
    {
        $this->tipo = $tipo;

        return $this;
    }

    /**
     * Get tipo.
     *
     * @return pessoas.tipo_nome_pessoa
     */
    public function getTipo()
    {
        return $this->tipo;
    }

    /**
     * Set nome.
     *
     * @param string $nome
     *
     * @return Nome
     */
    public function setNome($nome)
    {
        $this->nome = $nome;

        return $this;
    }

    /**
     * Get nome.
     *
     * @return string
     */
    public function getNome()
    {
        return $this->nome;
    }

    /**
     * Set idPessoa.
     *
     * @param \App\Entity\Pessoas\Pessoa|null $idPessoa
     *
     * @return Nome
     */
    public function setIdPessoa(\App\Entity\Pessoas\Pessoa $idPessoa = null)
    {
        $this->idPessoa = $idPessoa;

        return $this;
    }

    /**
     * Get idPessoa.
     *
     * @return \App\Entity\Pessoas\Pessoa|null
     */
    public function getIdPessoa()
    {
        return $this->idPessoa;
    }
}
