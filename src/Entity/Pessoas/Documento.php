<?php

namespace App\Entity\Pessoas;

/**
 * Documento
 */
class Documento
{
    /**
     * @var int
     */
    private $id;

    /**
     * @var pessoas.tipo_documento
     */
    private $tipo;

    /**
     * @var \DateTime
     */
    private $dataCadastro;

    /**
     * @var \App\Entity\Pessoas\Pessoa
     */
    private $pessoa;


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
     * @param pessoas.tipo_documento $tipo
     *
     * @return Documento
     */
    public function setTipo($tipo)
    {
        $this->tipo = $tipo;

        return $this;
    }

    /**
     * Get tipo.
     *
     * @return pessoas.tipo_documento
     */
    public function getTipo()
    {
        return $this->tipo;
    }

    /**
     * Set dataCadastro.
     *
     * @param \DateTime $dataCadastro
     *
     * @return Documento
     */
    public function setDataCadastro($dataCadastro)
    {
        $this->dataCadastro = $dataCadastro;

        return $this;
    }

    /**
     * Get dataCadastro.
     *
     * @return \DateTime
     */
    public function getDataCadastro()
    {
        return $this->dataCadastro;
    }

    /**
     * Set pessoa.
     *
     * @param \App\Entity\Pessoas\Pessoa|null $pessoa
     *
     * @return Documento
     */
    public function setPessoa(\App\Entity\Pessoas\Pessoa $pessoa = null)
    {
        $this->pessoa = $pessoa;

        return $this;
    }

    /**
     * Get pessoa.
     *
     * @return \App\Entity\Pessoas\Pessoa|null
     */
    public function getPessoa()
    {
        return $this->pessoa;
    }
}
