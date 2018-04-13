<?php

namespace App\Entity\Pessoas;

/**
 * Endereco
 */
class Endereco
{
    /**
     * @var int
     */
    private $id;

    /**
     * @var pessoas.tipo_endereco_pessoa
     */
    private $tipo;

    /**
     * @var string
     */
    private $pais;

    /**
     * @var string
     */
    private $estado;

    /**
     * @var string
     */
    private $uf;

    /**
     * @var string
     */
    private $cidade;

    /**
     * @var string
     */
    private $bairro;

    /**
     * @var string
     */
    private $logradouro;

    /**
     * @var string
     */
    private $numero;

    /**
     * @var string
     */
    private $cep;

    /**
     * @var point|null
     */
    private $localizacao;

    /**
     * @var string|null
     */
    private $complemento;

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
     * @param pessoas.tipo_endereco_pessoa $tipo
     *
     * @return Endereco
     */
    public function setTipo($tipo)
    {
        $this->tipo = $tipo;

        return $this;
    }

    /**
     * Get tipo.
     *
     * @return pessoas.tipo_endereco_pessoa
     */
    public function getTipo()
    {
        return $this->tipo;
    }

    /**
     * Set pais.
     *
     * @param string $pais
     *
     * @return Endereco
     */
    public function setPais($pais)
    {
        $this->pais = $pais;

        return $this;
    }

    /**
     * Get pais.
     *
     * @return string
     */
    public function getPais()
    {
        return $this->pais;
    }

    /**
     * Set estado.
     *
     * @param string $estado
     *
     * @return Endereco
     */
    public function setEstado($estado)
    {
        $this->estado = $estado;

        return $this;
    }

    /**
     * Get estado.
     *
     * @return string
     */
    public function getEstado()
    {
        return $this->estado;
    }

    /**
     * Set uf.
     *
     * @param string $uf
     *
     * @return Endereco
     */
    public function setUf($uf)
    {
        $this->uf = $uf;

        return $this;
    }

    /**
     * Get uf.
     *
     * @return string
     */
    public function getUf()
    {
        return $this->uf;
    }

    /**
     * Set cidade.
     *
     * @param string $cidade
     *
     * @return Endereco
     */
    public function setCidade($cidade)
    {
        $this->cidade = $cidade;

        return $this;
    }

    /**
     * Get cidade.
     *
     * @return string
     */
    public function getCidade()
    {
        return $this->cidade;
    }

    /**
     * Set bairro.
     *
     * @param string $bairro
     *
     * @return Endereco
     */
    public function setBairro($bairro)
    {
        $this->bairro = $bairro;

        return $this;
    }

    /**
     * Get bairro.
     *
     * @return string
     */
    public function getBairro()
    {
        return $this->bairro;
    }

    /**
     * Set logradouro.
     *
     * @param string $logradouro
     *
     * @return Endereco
     */
    public function setLogradouro($logradouro)
    {
        $this->logradouro = $logradouro;

        return $this;
    }

    /**
     * Get logradouro.
     *
     * @return string
     */
    public function getLogradouro()
    {
        return $this->logradouro;
    }

    /**
     * Set numero.
     *
     * @param string $numero
     *
     * @return Endereco
     */
    public function setNumero($numero)
    {
        $this->numero = $numero;

        return $this;
    }

    /**
     * Get numero.
     *
     * @return string
     */
    public function getNumero()
    {
        return $this->numero;
    }

    /**
     * Set cep.
     *
     * @param string $cep
     *
     * @return Endereco
     */
    public function setCep($cep)
    {
        $this->cep = $cep;

        return $this;
    }

    /**
     * Get cep.
     *
     * @return string
     */
    public function getCep()
    {
        return $this->cep;
    }

    /**
     * Set localizacao.
     *
     * @param point|null $localizacao
     *
     * @return Endereco
     */
    public function setLocalizacao($localizacao = null)
    {
        $this->localizacao = $localizacao;

        return $this;
    }

    /**
     * Get localizacao.
     *
     * @return point|null
     */
    public function getLocalizacao()
    {
        return $this->localizacao;
    }

    /**
     * Set complemento.
     *
     * @param string|null $complemento
     *
     * @return Endereco
     */
    public function setComplemento($complemento = null)
    {
        $this->complemento = $complemento;

        return $this;
    }

    /**
     * Get complemento.
     *
     * @return string|null
     */
    public function getComplemento()
    {
        return $this->complemento;
    }

    /**
     * Set idPessoa.
     *
     * @param \App\Entity\Pessoas\Pessoa|null $idPessoa
     *
     * @return Endereco
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
