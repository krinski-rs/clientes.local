<?php

namespace App\Entity\Pessoas;

/**
 * Pessoa
 */
class Pessoa
{
    /**
     * @var int
     */
    private $id;

    /**
     * @var pessoas.tipo_pessoa
     */
    private $tipo;

    /**
     * @var pessoas.nacionalidade_pessoa
     */
    private $nacionalidade;

    /**
     * @var \DateTime|null
     */
    private $dataAniversario;

    /**
     * @var \DateTime
     */
    private $dataCadastro = 'now()';

    /**
     * @var bool
     */
    private $ativo = true;

    /**
     * @var \Doctrine\Common\Collections\Collection
     */
    private $nomes;

    /**
     * @var \Doctrine\Common\Collections\Collection
     */
    private $enderecos;

    /**
     * @var \Doctrine\Common\Collections\Collection
     */
    private $documentos;

    /**
     * @var \Doctrine\Common\Collections\Collection
     */
    private $relacao;

    /**
     * Constructor
     */
    public function __construct()
    {
        $this->nomes = new \Doctrine\Common\Collections\ArrayCollection();
        $this->enderecos = new \Doctrine\Common\Collections\ArrayCollection();
        $this->documentos = new \Doctrine\Common\Collections\ArrayCollection();
        $this->relacao = new \Doctrine\Common\Collections\ArrayCollection();
    }

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
     * @param pessoas.tipo_pessoa $tipo
     *
     * @return Pessoa
     */
    public function setTipo($tipo)
    {
        $this->tipo = $tipo;

        return $this;
    }

    /**
     * Get tipo.
     *
     * @return pessoas.tipo_pessoa
     */
    public function getTipo()
    {
        return $this->tipo;
    }

    /**
     * Set nacionalidade.
     *
     * @param pessoas.nacionalidade_pessoa $nacionalidade
     *
     * @return Pessoa
     */
    public function setNacionalidade($nacionalidade)
    {
        $this->nacionalidade = $nacionalidade;

        return $this;
    }

    /**
     * Get nacionalidade.
     *
     * @return pessoas.nacionalidade_pessoa
     */
    public function getNacionalidade()
    {
        return $this->nacionalidade;
    }

    /**
     * Set dataAniversario.
     *
     * @param \DateTime|null $dataAniversario
     *
     * @return Pessoa
     */
    public function setDataAniversario($dataAniversario = null)
    {
        $this->dataAniversario = $dataAniversario;

        return $this;
    }

    /**
     * Get dataAniversario.
     *
     * @return \DateTime|null
     */
    public function getDataAniversario()
    {
        return $this->dataAniversario;
    }

    /**
     * Set dataCadastro.
     *
     * @param \DateTime $dataCadastro
     *
     * @return Pessoa
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
     * Set ativo.
     *
     * @param bool $ativo
     *
     * @return Pessoa
     */
    public function setAtivo($ativo)
    {
        $this->ativo = $ativo;

        return $this;
    }

    /**
     * Get ativo.
     *
     * @return bool
     */
    public function getAtivo()
    {
        return $this->ativo;
    }

    /**
     * Add nome.
     *
     * @param \App\Entity\Pessoas\Nome $nome
     *
     * @return Pessoa
     */
    public function addNome(\App\Entity\Pessoas\Nome $nome)
    {
        $this->nomes[] = $nome;

        return $this;
    }

    /**
     * Remove nome.
     *
     * @param \App\Entity\Pessoas\Nome $nome
     *
     * @return boolean TRUE if this collection contained the specified element, FALSE otherwise.
     */
    public function removeNome(\App\Entity\Pessoas\Nome $nome)
    {
        return $this->nomes->removeElement($nome);
    }

    /**
     * Get nomes.
     *
     * @return \Doctrine\Common\Collections\Collection
     */
    public function getNomes()
    {
        return $this->nomes;
    }

    /**
     * Add endereco.
     *
     * @param \App\Entity\Pessoas\Endereco $endereco
     *
     * @return Pessoa
     */
    public function addEndereco(\App\Entity\Pessoas\Endereco $endereco)
    {
        $this->enderecos[] = $endereco;

        return $this;
    }

    /**
     * Remove endereco.
     *
     * @param \App\Entity\Pessoas\Endereco $endereco
     *
     * @return boolean TRUE if this collection contained the specified element, FALSE otherwise.
     */
    public function removeEndereco(\App\Entity\Pessoas\Endereco $endereco)
    {
        return $this->enderecos->removeElement($endereco);
    }

    /**
     * Get enderecos.
     *
     * @return \Doctrine\Common\Collections\Collection
     */
    public function getEnderecos()
    {
        return $this->enderecos;
    }

    /**
     * Add documento.
     *
     * @param \App\Entity\Pessoas\Documento $documento
     *
     * @return Pessoa
     */
    public function addDocumento(\App\Entity\Pessoas\Documento $documento)
    {
        $this->documentos[] = $documento;

        return $this;
    }

    /**
     * Remove documento.
     *
     * @param \App\Entity\Pessoas\Documento $documento
     *
     * @return boolean TRUE if this collection contained the specified element, FALSE otherwise.
     */
    public function removeDocumento(\App\Entity\Pessoas\Documento $documento)
    {
        return $this->documentos->removeElement($documento);
    }

    /**
     * Get documentos.
     *
     * @return \Doctrine\Common\Collections\Collection
     */
    public function getDocumentos()
    {
        return $this->documentos;
    }

    /**
     * Add relacao.
     *
     * @param \App\Entity\Pessoas\PessoaToPessoa $relacao
     *
     * @return Pessoa
     */
    public function addRelacao(\App\Entity\Pessoas\PessoaToPessoa $relacao)
    {
        $this->relacao[] = $relacao;

        return $this;
    }

    /**
     * Remove relacao.
     *
     * @param \App\Entity\Pessoas\PessoaToPessoa $relacao
     *
     * @return boolean TRUE if this collection contained the specified element, FALSE otherwise.
     */
    public function removeRelacao(\App\Entity\Pessoas\PessoaToPessoa $relacao)
    {
        return $this->relacao->removeElement($relacao);
    }

    /**
     * Get relacao.
     *
     * @return \Doctrine\Common\Collections\Collection
     */
    public function getRelacao()
    {
        return $this->relacao;
    }
}
