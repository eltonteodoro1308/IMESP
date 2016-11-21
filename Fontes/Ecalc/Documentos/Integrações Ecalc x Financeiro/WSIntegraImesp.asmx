<?xml version="1.0" encoding="utf-8"?>
<wsdl:definitions xmlns:s="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://schemas.xmlsoap.org/wsdl/soap12/" xmlns:http="http://schemas.xmlsoap.org/wsdl/http/" xmlns:mime="http://schemas.xmlsoap.org/wsdl/mime/" xmlns:tns="http://tempuri.org/" xmlns:soap="http://schemas.xmlsoap.org/wsdl/soap/" xmlns:tm="http://microsoft.com/wsdl/mime/textMatching/" xmlns:soapenc="http://schemas.xmlsoap.org/soap/encoding/" targetNamespace="http://tempuri.org/" xmlns:wsdl="http://schemas.xmlsoap.org/wsdl/">
  <wsdl:types>
    <s:schema elementFormDefault="qualified" targetNamespace="http://tempuri.org/">
      <s:element name="salvarVendedor">
        <s:complexType>
          <s:sequence>
            <s:element minOccurs="0" maxOccurs="1" name="token" type="tns:AccessToken" />
            <s:element minOccurs="0" maxOccurs="1" name="id" type="s:string" />
            <s:element minOccurs="0" maxOccurs="1" name="nome" type="s:string" />
            <s:element minOccurs="0" maxOccurs="1" name="razaoSocial" type="s:string" />
            <s:element minOccurs="1" maxOccurs="1" name="ativo" type="s:boolean" />
            <s:element minOccurs="0" maxOccurs="1" name="cpf" type="s:string" />
            <s:element minOccurs="0" maxOccurs="1" name="cnpj" type="s:string" />
            <s:element minOccurs="0" maxOccurs="1" name="endereco" type="s:string" />
            <s:element minOccurs="0" maxOccurs="1" name="codMunicipioIBGE" type="s:string" />
            <s:element minOccurs="0" maxOccurs="1" name="estado" type="s:string" />
            <s:element minOccurs="0" maxOccurs="1" name="cep" type="s:string" />
            <s:element minOccurs="0" maxOccurs="1" name="ddd" type="s:string" />
            <s:element minOccurs="0" maxOccurs="1" name="telefone" type="s:string" />
            <s:element minOccurs="0" maxOccurs="1" name="fax" type="s:string" />
            <s:element minOccurs="0" maxOccurs="1" name="email" type="s:string" />
            <s:element minOccurs="1" maxOccurs="1" name="comissao" type="s:double" />
          </s:sequence>
        </s:complexType>
      </s:element>
      <s:complexType name="AccessToken">
        <s:sequence>
          <s:element minOccurs="0" maxOccurs="1" name="Usuario" type="s:string" />
          <s:element minOccurs="0" maxOccurs="1" name="Senha" type="s:string" />
        </s:sequence>
      </s:complexType>
      <s:element name="salvarVendedorResponse">
        <s:complexType>
          <s:sequence>
            <s:element minOccurs="0" maxOccurs="1" name="salvarVendedorResult" type="tns:WSResponse" />
          </s:sequence>
        </s:complexType>
      </s:element>
      <s:complexType name="WSResponse">
        <s:sequence>
          <s:element minOccurs="1" maxOccurs="1" name="Sucesso" type="s:boolean" />
          <s:element minOccurs="1" maxOccurs="1" name="IDRetorno" type="s:int" />
          <s:element minOccurs="0" maxOccurs="1" name="Mensagem" type="s:string" />
        </s:sequence>
      </s:complexType>
      <s:element name="salvarCondicaoDePagamento">
        <s:complexType>
          <s:sequence>
            <s:element minOccurs="0" maxOccurs="1" name="token" type="tns:AccessToken" />
            <s:element minOccurs="0" maxOccurs="1" name="id" type="s:string" />
            <s:element minOccurs="0" maxOccurs="1" name="descricao" type="s:string" />
            <s:element minOccurs="1" maxOccurs="1" name="ativo" type="s:boolean" />
            <s:element minOccurs="0" maxOccurs="1" name="parcelasDiasVariaveis" type="tns:ArrayOfParcelaDiaVariavelVO" />
          </s:sequence>
        </s:complexType>
      </s:element>
      <s:complexType name="ArrayOfParcelaDiaVariavelVO">
        <s:sequence>
          <s:element minOccurs="0" maxOccurs="unbounded" name="ParcelaDiaVariavelVO" nillable="true" type="tns:ParcelaDiaVariavelVO" />
        </s:sequence>
      </s:complexType>
      <s:complexType name="ParcelaDiaVariavelVO">
        <s:complexContent mixed="false">
          <s:extension base="tns:EcalcValueObject">
            <s:sequence>
              <s:element minOccurs="1" maxOccurs="1" name="Codigo" type="s:int" />
              <s:element minOccurs="1" maxOccurs="1" name="CodigoCondicaoDePagamento" type="s:int" />
              <s:element minOccurs="1" maxOccurs="1" name="Adicionar" type="s:boolean" />
              <s:element minOccurs="1" maxOccurs="1" name="Percentual" type="s:double" />
              <s:element minOccurs="1" maxOccurs="1" name="Dias" type="s:int" />
              <s:element minOccurs="1" maxOccurs="1" name="PercentualIPI" type="s:double" />
            </s:sequence>
          </s:extension>
        </s:complexContent>
      </s:complexType>
      <s:complexType name="EcalcValueObject">
        <s:sequence>
          <s:element minOccurs="1" maxOccurs="1" name="LazyObject" type="s:boolean" />
          <s:element minOccurs="1" maxOccurs="1" name="hasCache" type="s:boolean" />
          <s:element minOccurs="1" maxOccurs="1" name="loadClusterd" type="s:boolean" />
          <s:element minOccurs="0" maxOccurs="1" name="Erros" type="tns:ListaErros" />
        </s:sequence>
      </s:complexType>
      <s:complexType name="ListaErros">
        <s:sequence>
          <s:element minOccurs="0" maxOccurs="1" name="Errors" type="tns:ArrayOfErrorStruct" />
          <s:element minOccurs="0" maxOccurs="1" name="SucessMsg" type="s:string" />
        </s:sequence>
      </s:complexType>
      <s:complexType name="ArrayOfErrorStruct">
        <s:sequence>
          <s:element minOccurs="0" maxOccurs="unbounded" name="ErrorStruct" nillable="true" type="tns:ErrorStruct" />
        </s:sequence>
      </s:complexType>
      <s:complexType name="ErrorStruct">
        <s:sequence>
          <s:element minOccurs="0" maxOccurs="1" name="errorKey" type="s:string" />
          <s:element minOccurs="1" maxOccurs="1" name="objKey" type="s:int" />
          <s:element minOccurs="0" maxOccurs="1" name="Error" type="s:string" />
          <s:element minOccurs="1" maxOccurs="1" name="ErrorType" type="tns:ErrorType" />
        </s:sequence>
      </s:complexType>
      <s:simpleType name="ErrorType">
        <s:restriction base="s:string">
          <s:enumeration value="Undefined" />
          <s:enumeration value="Error" />
          <s:enumeration value="Warning" />
          <s:enumeration value="Confirmation" />
        </s:restriction>
      </s:simpleType>
      <s:element name="salvarCondicaoDePagamentoResponse">
        <s:complexType>
          <s:sequence>
            <s:element minOccurs="0" maxOccurs="1" name="salvarCondicaoDePagamentoResult" type="tns:WSResponse" />
          </s:sequence>
        </s:complexType>
      </s:element>
      <s:element name="salvarCentroDeCusto">
        <s:complexType>
          <s:sequence>
            <s:element minOccurs="0" maxOccurs="1" name="token" type="tns:AccessToken" />
            <s:element minOccurs="0" maxOccurs="1" name="id" type="s:string" />
            <s:element minOccurs="0" maxOccurs="1" name="nome" type="s:string" />
            <s:element minOccurs="1" maxOccurs="1" name="ativo" type="s:boolean" />
          </s:sequence>
        </s:complexType>
      </s:element>
      <s:element name="salvarCentroDeCustoResponse">
        <s:complexType>
          <s:sequence>
            <s:element minOccurs="0" maxOccurs="1" name="salvarCentroDeCustoResult" type="tns:WSResponse" />
          </s:sequence>
        </s:complexType>
      </s:element>
      <s:element name="salvarMateriaPrima">
        <s:complexType>
          <s:sequence>
            <s:element minOccurs="0" maxOccurs="1" name="token" type="tns:AccessToken" />
            <s:element minOccurs="0" maxOccurs="1" name="id" type="s:string" />
            <s:element minOccurs="0" maxOccurs="1" name="codigoFamilia" type="s:string" />
            <s:element minOccurs="0" maxOccurs="1" name="nome" type="s:string" />
            <s:element minOccurs="1" maxOccurs="1" name="ativo" type="s:boolean" />
            <s:element minOccurs="1" maxOccurs="1" name="custo" type="s:double" />
          </s:sequence>
        </s:complexType>
      </s:element>
      <s:element name="salvarMateriaPrimaResponse">
        <s:complexType>
          <s:sequence>
            <s:element minOccurs="0" maxOccurs="1" name="salvarMateriaPrimaResult" type="tns:WSResponse" />
          </s:sequence>
        </s:complexType>
      </s:element>
      <s:element name="salvarUnidade">
        <s:complexType>
          <s:sequence>
            <s:element minOccurs="0" maxOccurs="1" name="token" type="tns:AccessToken" />
            <s:element minOccurs="0" maxOccurs="1" name="id" type="s:string" />
            <s:element minOccurs="0" maxOccurs="1" name="nomeAbreviado" type="s:string" />
            <s:element minOccurs="0" maxOccurs="1" name="descricao" type="s:string" />
            <s:element minOccurs="1" maxOccurs="1" name="operador" type="s:int" />
            <s:element minOccurs="1" maxOccurs="1" name="multiplicador" type="s:double" />
            <s:element minOccurs="1" maxOccurs="1" name="ativo" type="s:boolean" />
          </s:sequence>
        </s:complexType>
      </s:element>
      <s:element name="salvarUnidadeResponse">
        <s:complexType>
          <s:sequence>
            <s:element minOccurs="0" maxOccurs="1" name="salvarUnidadeResult" type="tns:WSResponse" />
          </s:sequence>
        </s:complexType>
      </s:element>
      <s:element name="salvarPapel">
        <s:complexType>
          <s:sequence>
            <s:element minOccurs="0" maxOccurs="1" name="token" type="tns:AccessToken" />
            <s:element minOccurs="0" maxOccurs="1" name="id" type="s:string" />
            <s:element minOccurs="0" maxOccurs="1" name="codigoFamilia" type="s:string" />
            <s:element minOccurs="0" maxOccurs="1" name="nomeFamilia" type="s:string" />
            <s:element minOccurs="1" maxOccurs="1" name="ativo" type="s:boolean" />
            <s:element minOccurs="1" maxOccurs="1" name="largura" type="s:double" />
            <s:element minOccurs="1" maxOccurs="1" name="altura" type="s:double" />
            <s:element minOccurs="1" maxOccurs="1" name="gramatura" type="s:int" />
            <s:element minOccurs="1" maxOccurs="1" name="custo" type="s:double" />
            <s:element minOccurs="1" maxOccurs="1" name="papelDeReposicao" type="s:boolean" />
            <s:element minOccurs="1" maxOccurs="1" name="papelImune" type="s:boolean" />
            <s:element minOccurs="1" maxOccurs="1" name="folhasPorPacote" type="s:int" />
          </s:sequence>
        </s:complexType>
      </s:element>
      <s:element name="salvarPapelResponse">
        <s:complexType>
          <s:sequence>
            <s:element minOccurs="0" maxOccurs="1" name="salvarPapelResult" type="tns:WSResponse" />
          </s:sequence>
        </s:complexType>
      </s:element>
      <s:element name="salvarProdutoAcabado">
        <s:complexType>
          <s:sequence>
            <s:element minOccurs="0" maxOccurs="1" name="token" type="tns:AccessToken" />
            <s:element minOccurs="0" maxOccurs="1" name="id" type="s:string" />
            <s:element minOccurs="0" maxOccurs="1" name="nome" type="s:string" />
            <s:element minOccurs="0" maxOccurs="1" name="descricao" type="s:string" />
            <s:element minOccurs="1" maxOccurs="1" name="ativo" type="s:boolean" />
          </s:sequence>
        </s:complexType>
      </s:element>
      <s:element name="salvarProdutoAcabadoResponse">
        <s:complexType>
          <s:sequence>
            <s:element minOccurs="0" maxOccurs="1" name="salvarProdutoAcabadoResult" type="tns:WSResponse" />
          </s:sequence>
        </s:complexType>
      </s:element>
      <s:element name="salvarEstoque">
        <s:complexType>
          <s:sequence>
            <s:element minOccurs="0" maxOccurs="1" name="token" type="tns:AccessToken" />
            <s:element minOccurs="0" maxOccurs="1" name="id" type="s:string" />
            <s:element minOccurs="1" maxOccurs="1" name="quantidade" type="s:double" />
          </s:sequence>
        </s:complexType>
      </s:element>
      <s:element name="salvarEstoqueResponse">
        <s:complexType>
          <s:sequence>
            <s:element minOccurs="0" maxOccurs="1" name="salvarEstoqueResult" type="tns:WSResponse" />
          </s:sequence>
        </s:complexType>
      </s:element>
      <s:element name="salvarOperador">
        <s:complexType>
          <s:sequence>
            <s:element minOccurs="0" maxOccurs="1" name="token" type="tns:AccessToken" />
            <s:element minOccurs="0" maxOccurs="1" name="id" type="s:string" />
            <s:element minOccurs="0" maxOccurs="1" name="nome" type="s:string" />
            <s:element minOccurs="1" maxOccurs="1" name="ativo" type="s:boolean" />
          </s:sequence>
        </s:complexType>
      </s:element>
      <s:element name="salvarOperadorResponse">
        <s:complexType>
          <s:sequence>
            <s:element minOccurs="0" maxOccurs="1" name="salvarOperadorResult" type="tns:WSResponse" />
          </s:sequence>
        </s:complexType>
      </s:element>
      <s:element name="salvarFeriado">
        <s:complexType>
          <s:sequence>
            <s:element minOccurs="0" maxOccurs="1" name="token" type="tns:AccessToken" />
            <s:element minOccurs="0" maxOccurs="1" name="id" type="s:string" />
            <s:element minOccurs="1" maxOccurs="1" name="feriado" type="s:dateTime" />
            <s:element minOccurs="1" maxOccurs="1" name="dataFixa" type="s:boolean" />
          </s:sequence>
        </s:complexType>
      </s:element>
      <s:element name="salvarFeriadoResponse">
        <s:complexType>
          <s:sequence>
            <s:element minOccurs="0" maxOccurs="1" name="salvarFeriadoResult" type="tns:WSResponse" />
          </s:sequence>
        </s:complexType>
      </s:element>
      <s:element name="salvarTransportadora">
        <s:complexType>
          <s:sequence>
            <s:element minOccurs="0" maxOccurs="1" name="token" type="tns:AccessToken" />
            <s:element minOccurs="0" maxOccurs="1" name="id" type="s:string" />
            <s:element minOccurs="0" maxOccurs="1" name="nome" type="s:string" />
            <s:element minOccurs="0" maxOccurs="1" name="razaoSocial" type="s:string" />
            <s:element minOccurs="1" maxOccurs="1" name="ativo" type="s:boolean" />
            <s:element minOccurs="0" maxOccurs="1" name="CPF" type="s:string" />
            <s:element minOccurs="0" maxOccurs="1" name="CNPJ" type="s:string" />
            <s:element minOccurs="0" maxOccurs="1" name="inscEstadual" type="s:string" />
            <s:element minOccurs="0" maxOccurs="1" name="inscMunicipal" type="s:string" />
            <s:element minOccurs="0" maxOccurs="1" name="endereco" type="s:string" />
            <s:element minOccurs="0" maxOccurs="1" name="bairro" type="s:string" />
            <s:element minOccurs="0" maxOccurs="1" name="codMunicipioIBGE" type="s:string" />
            <s:element minOccurs="0" maxOccurs="1" name="estado" type="s:string" />
            <s:element minOccurs="0" maxOccurs="1" name="cep" type="s:string" />
            <s:element minOccurs="0" maxOccurs="1" name="DDD" type="s:string" />
            <s:element minOccurs="0" maxOccurs="1" name="telefone" type="s:string" />
            <s:element minOccurs="0" maxOccurs="1" name="fax" type="s:string" />
            <s:element minOccurs="0" maxOccurs="1" name="email" type="s:string" />
          </s:sequence>
        </s:complexType>
      </s:element>
      <s:element name="salvarTransportadoraResponse">
        <s:complexType>
          <s:sequence>
            <s:element minOccurs="0" maxOccurs="1" name="salvarTransportadoraResult" type="tns:WSResponse" />
          </s:sequence>
        </s:complexType>
      </s:element>
      <s:element name="salvarNaturezaDeOperacao">
        <s:complexType>
          <s:sequence>
            <s:element minOccurs="0" maxOccurs="1" name="token" type="tns:AccessToken" />
            <s:element minOccurs="0" maxOccurs="1" name="id" type="s:string" />
            <s:element minOccurs="0" maxOccurs="1" name="nome" type="s:string" />
            <s:element minOccurs="0" maxOccurs="1" name="cfop" type="s:string" />
            <s:element minOccurs="1" maxOccurs="1" name="ativo" type="s:boolean" />
          </s:sequence>
        </s:complexType>
      </s:element>
      <s:element name="salvarNaturezaDeOperacaoResponse">
        <s:complexType>
          <s:sequence>
            <s:element minOccurs="0" maxOccurs="1" name="salvarNaturezaDeOperacaoResult" type="tns:WSResponse" />
          </s:sequence>
        </s:complexType>
      </s:element>
      <s:element name="salvarVenda">
        <s:complexType>
          <s:sequence>
            <s:element minOccurs="0" maxOccurs="1" name="token" type="tns:AccessToken" />
            <s:element minOccurs="1" maxOccurs="1" name="id" type="s:int" />
            <s:element minOccurs="1" maxOccurs="1" name="dataEntrega" type="s:dateTime" />
            <s:element minOccurs="1" maxOccurs="1" name="status" type="tns:TStatusVenda" />
          </s:sequence>
        </s:complexType>
      </s:element>
      <s:simpleType name="TStatusVenda">
        <s:restriction base="s:string">
          <s:enumeration value="tIndefinido" />
          <s:enumeration value="tPrevisao" />
          <s:enumeration value="tConfirmado" />
          <s:enumeration value="tEntregue" />
        </s:restriction>
      </s:simpleType>
      <s:element name="salvarVendaResponse">
        <s:complexType>
          <s:sequence>
            <s:element minOccurs="0" maxOccurs="1" name="salvarVendaResult" type="tns:WSResponse" />
          </s:sequence>
        </s:complexType>
      </s:element>
      <s:element name="salvarTipoCliente">
        <s:complexType>
          <s:sequence>
            <s:element minOccurs="0" maxOccurs="1" name="token" type="tns:AccessToken" />
            <s:element minOccurs="0" maxOccurs="1" name="id" type="s:string" />
            <s:element minOccurs="0" maxOccurs="1" name="nome" type="s:string" />
          </s:sequence>
        </s:complexType>
      </s:element>
      <s:element name="salvarTipoClienteResponse">
        <s:complexType>
          <s:sequence>
            <s:element minOccurs="0" maxOccurs="1" name="salvarTipoClienteResult" type="tns:WSResponse" />
          </s:sequence>
        </s:complexType>
      </s:element>
      <s:element name="salvarNotaFiscal">
        <s:complexType>
          <s:sequence>
            <s:element minOccurs="0" maxOccurs="1" name="token" type="tns:AccessToken" />
            <s:element minOccurs="0" maxOccurs="1" name="id" type="s:string" />
            <s:element minOccurs="1" maxOccurs="1" name="numeroNota" type="s:int" />
            <s:element minOccurs="0" maxOccurs="1" name="serie" type="s:string" />
            <s:element minOccurs="0" maxOccurs="1" name="clienteID" type="s:string" />
            <s:element minOccurs="1" maxOccurs="1" name="dataEntrega" type="s:dateTime" />
            <s:element minOccurs="1" maxOccurs="1" name="dataSaida" type="s:dateTime" />
            <s:element minOccurs="1" maxOccurs="1" name="valorTotal" type="s:double" />
            <s:element minOccurs="1" maxOccurs="1" name="valorNota" type="s:double" />
            <s:element minOccurs="0" maxOccurs="1" name="obs" type="s:string" />
            <s:element minOccurs="1" maxOccurs="1" name="vendaID" type="s:int" />
            <s:element minOccurs="1" maxOccurs="1" name="status" type="tns:TStatusNF" />
          </s:sequence>
        </s:complexType>
      </s:element>
      <s:simpleType name="TStatusNF">
        <s:restriction base="s:string">
          <s:enumeration value="tIndefinido" />
          <s:enumeration value="tEmitida" />
          <s:enumeration value="tCancelada" />
        </s:restriction>
      </s:simpleType>
      <s:element name="salvarNotaFiscalResponse">
        <s:complexType>
          <s:sequence>
            <s:element minOccurs="0" maxOccurs="1" name="salvarNotaFiscalResult" type="tns:WSResponse" />
          </s:sequence>
        </s:complexType>
      </s:element>
      <s:element name="confirmarIntegracao">
        <s:complexType>
          <s:sequence>
            <s:element minOccurs="0" maxOccurs="1" name="token" type="tns:AccessToken" />
            <s:element minOccurs="1" maxOccurs="1" name="tipo" type="tns:TTipoConfirmacao" />
            <s:element minOccurs="0" maxOccurs="1" name="listaID" type="tns:ArrayOfInt" />
          </s:sequence>
        </s:complexType>
      </s:element>
      <s:simpleType name="TTipoConfirmacao">
        <s:restriction base="s:string">
          <s:enumeration value="tMaquina" />
          <s:enumeration value="tAvisoDeProducao" />
          <s:enumeration value="tVenda" />
          <s:enumeration value="tMaterialOS" />
          <s:enumeration value="tApontamento" />
          <s:enumeration value="tOrdemDeServico" />
        </s:restriction>
      </s:simpleType>
      <s:complexType name="ArrayOfInt">
        <s:sequence>
          <s:element minOccurs="0" maxOccurs="unbounded" name="int" type="s:int" />
        </s:sequence>
      </s:complexType>
      <s:element name="confirmarIntegracaoResponse">
        <s:complexType>
          <s:sequence>
            <s:element minOccurs="0" maxOccurs="1" name="confirmarIntegracaoResult" type="tns:WSResponse" />
          </s:sequence>
        </s:complexType>
      </s:element>
      <s:element name="carregarMaquinas">
        <s:complexType>
          <s:sequence>
            <s:element minOccurs="0" maxOccurs="1" name="token" type="tns:AccessToken" />
            <s:element minOccurs="1" maxOccurs="1" name="ativos" type="s:boolean" />
          </s:sequence>
        </s:complexType>
      </s:element>
      <s:element name="carregarMaquinasResponse">
        <s:complexType>
          <s:sequence>
            <s:element minOccurs="0" maxOccurs="1" name="carregarMaquinasResult" type="tns:ArrayOfMaquinaVO" />
          </s:sequence>
        </s:complexType>
      </s:element>
      <s:complexType name="ArrayOfMaquinaVO">
        <s:sequence>
          <s:element minOccurs="0" maxOccurs="unbounded" name="MaquinaVO" nillable="true" type="tns:MaquinaVO" />
        </s:sequence>
      </s:complexType>
      <s:complexType name="MaquinaVO">
        <s:complexContent mixed="false">
          <s:extension base="tns:EcalcValueObject">
            <s:sequence>
              <s:element minOccurs="1" maxOccurs="1" name="ID" type="s:int" />
              <s:element minOccurs="0" maxOccurs="1" name="Maquina" type="s:string" />
              <s:element minOccurs="0" maxOccurs="1" name="Apelido" type="s:string" />
              <s:element minOccurs="1" maxOccurs="1" name="CustoHora" type="s:double" />
              <s:element minOccurs="1" maxOccurs="1" name="Mediaprod" type="s:double" />
              <s:element minOccurs="1" maxOccurs="1" name="CustoHoraExtra" type="s:double" />
              <s:element minOccurs="1" maxOccurs="1" name="EventoProducao" type="s:int" />
              <s:element minOccurs="1" maxOccurs="1" name="EventoAcerto" type="s:int" />
              <s:element minOccurs="1" maxOccurs="1" name="TipoMaquina" type="tns:TipoMaquina" />
              <s:element minOccurs="1" maxOccurs="1" name="Status" type="s:boolean" />
              <s:element minOccurs="1" maxOccurs="1" name="SetorID" type="s:int" />
              <s:element minOccurs="1" maxOccurs="1" name="Empresa" type="s:int" />
              <s:element minOccurs="1" maxOccurs="1" name="NaoTrocaOS" type="s:boolean" />
              <s:element minOccurs="1" maxOccurs="1" name="ZerarNumeradorMaquinaAoFinalizarProc" type="s:boolean" />
              <s:element minOccurs="1" maxOccurs="1" name="VelocidadeMaxima" type="s:int" />
              <s:element minOccurs="1" maxOccurs="1" name="TimeoutParada" type="s:int" />
              <s:element minOccurs="0" maxOccurs="1" name="ImagemDir" type="s:string" />
              <s:element minOccurs="1" maxOccurs="1" name="PortaSerial" type="s:int" />
              <s:element minOccurs="1" maxOccurs="1" name="TipoPerda" type="s:int" />
              <s:element minOccurs="1" maxOccurs="1" name="IncrementoPerda" type="s:int" />
              <s:element minOccurs="0" maxOccurs="1" name="LeituraApontamentoDir" type="s:string" />
              <s:element minOccurs="1" maxOccurs="1" name="LeituraApontamentoTipo" type="tns:TipoEletronico" />
              <s:element minOccurs="1" maxOccurs="1" name="UsaCoeficienteQuantidade" type="s:boolean" />
              <s:element minOccurs="1" maxOccurs="1" name="ContadorApontamento" type="s:int" />
              <s:element minOccurs="1" maxOccurs="1" name="UsaNumeradorDaMaquina" type="s:boolean" />
              <s:element minOccurs="1" maxOccurs="1" name="NumeradorDaMaquina" type="s:int" />
              <s:element minOccurs="1" maxOccurs="1" name="Grupo" type="s:int" />
              <s:element minOccurs="1" maxOccurs="1" name="EventoOcioso" type="s:int" />
              <s:element minOccurs="1" maxOccurs="1" name="ProxInicio" nillable="true" type="s:dateTime" />
              <s:element minOccurs="1" maxOccurs="1" name="NumRecursos" type="s:int" />
              <s:element minOccurs="0" maxOccurs="1" name="EndMemoriaPLC" type="s:string" />
              <s:element minOccurs="0" maxOccurs="1" name="EndMemoriaAux" type="s:string" />
              <s:element minOccurs="1" maxOccurs="1" name="PercentualMinimoParaFinalizacao" type="s:double" />
              <s:element minOccurs="1" maxOccurs="1" name="RatearEquipe" type="s:boolean" />
              <s:element minOccurs="1" maxOccurs="1" name="IdxMaqPLCEcalc" type="s:int" />
              <s:element minOccurs="1" maxOccurs="1" name="MaquinaPreferencial" type="s:boolean" />
              <s:element minOccurs="1" maxOccurs="1" name="CoeficienteAcerto" type="s:double" />
              <s:element minOccurs="1" maxOccurs="1" name="CoeficienteProducao" type="s:double" />
              <s:element minOccurs="1" maxOccurs="1" name="PermiteOperadoresSimultaneos" type="s:boolean" />
              <s:element minOccurs="1" maxOccurs="1" name="ContadorTipo" type="tns:ContadorTipo" />
              <s:element minOccurs="1" maxOccurs="1" name="Ordem" type="s:int" />
              <s:element minOccurs="1" maxOccurs="1" name="TipoBalancaPerda" type="tns:TipoBalancaPerda" />
              <s:element minOccurs="1" maxOccurs="1" name="PesoBalancaAtual" type="s:double" />
              <s:element minOccurs="1" maxOccurs="1" name="AcertoComoPerdaNaProducao" type="s:boolean" />
              <s:element minOccurs="1" maxOccurs="1" name="PermiteMultiplicarProc" type="s:boolean" />
              <s:element minOccurs="1" maxOccurs="1" name="PesoBalancaCalibracao" type="s:double" />
              <s:element minOccurs="0" maxOccurs="1" name="Prefixo" type="s:string" />
              <s:element minOccurs="1" maxOccurs="1" name="FolhasBalancaCalibracao" type="s:int" />
              <s:element minOccurs="1" maxOccurs="1" name="ExcedenteProdComoPerda" type="s:boolean" />
              <s:element minOccurs="1" maxOccurs="1" name="Integracao" type="s:int" />
              <s:element minOccurs="1" maxOccurs="1" name="VelocidadeProdAuto" type="s:int" />
              <s:element minOccurs="1" maxOccurs="1" name="TempoProdAuto" type="s:int" />
              <s:element minOccurs="1" maxOccurs="1" name="NaoIniciarProximaTarefa" type="s:boolean" />
              <s:element minOccurs="1" maxOccurs="1" name="PerdaInicial" type="s:int" />
              <s:element minOccurs="1" maxOccurs="1" name="permiteIndicarPerdaProcessoAnte" type="s:boolean" />
              <s:element minOccurs="1" maxOccurs="1" name="CalcularPesoAutomaticamenteNaBalanca" type="s:boolean" />
              <s:element minOccurs="1" maxOccurs="1" name="ConverteParaMetroLinear" type="s:boolean" />
              <s:element minOccurs="0" maxOccurs="1" name="grupoMaquinaPCP" type="tns:GrupoMaquinaPCPVO" />
              <s:element minOccurs="1" maxOccurs="1" name="AgendaPadrao" type="s:int" />
            </s:sequence>
          </s:extension>
        </s:complexContent>
      </s:complexType>
      <s:simpleType name="TipoMaquina">
        <s:restriction base="s:string">
          <s:enumeration value="Padrao" />
          <s:enumeration value="Terceirizada" />
          <s:enumeration value="PorFuncionario" />
          <s:enumeration value="Funcionario" />
          <s:enumeration value="TerceirizadaPorFuncionario" />
        </s:restriction>
      </s:simpleType>
      <s:simpleType name="TipoEletronico">
        <s:restriction base="s:string">
          <s:enumeration value="Nenhuma" />
          <s:enumeration value="PLC" />
          <s:enumeration value="Atmel" />
          <s:enumeration value="RSLinx" />
          <s:enumeration value="PLCNovus" />
          <s:enumeration value="PLCEcalc" />
        </s:restriction>
      </s:simpleType>
      <s:simpleType name="ContadorTipo">
        <s:restriction base="s:string">
          <s:enumeration value="indefinido" />
          <s:enumeration value="producao" />
          <s:enumeration value="acerto" />
        </s:restriction>
      </s:simpleType>
      <s:simpleType name="TipoBalancaPerda">
        <s:restriction base="s:string">
          <s:enumeration value="Nenhuma" />
          <s:enumeration value="ManualPesoParcial" />
          <s:enumeration value="ManualPesoAcumulado" />
          <s:enumeration value="Filizola" />
        </s:restriction>
      </s:simpleType>
      <s:complexType name="GrupoMaquinaPCPVO">
        <s:complexContent mixed="false">
          <s:extension base="tns:EcalcValueObject">
            <s:sequence>
              <s:element minOccurs="1" maxOccurs="1" name="Codseq" type="s:int" />
              <s:element minOccurs="0" maxOccurs="1" name="Grupo" type="s:string" />
              <s:element minOccurs="1" maxOccurs="1" name="CodCCusto" type="s:int" />
              <s:element minOccurs="0" maxOccurs="1" name="EspecMaq1" type="s:string" />
              <s:element minOccurs="0" maxOccurs="1" name="EspecMaq2" type="s:string" />
              <s:element minOccurs="0" maxOccurs="1" name="EspecMaq3" type="s:string" />
              <s:element minOccurs="0" maxOccurs="1" name="EspecMaq4" type="s:string" />
              <s:element minOccurs="0" maxOccurs="1" name="EspecMaq5" type="s:string" />
              <s:element minOccurs="0" maxOccurs="1" name="EspecPro1" type="s:string" />
              <s:element minOccurs="0" maxOccurs="1" name="EspecPro2" type="s:string" />
              <s:element minOccurs="0" maxOccurs="1" name="EspecPro3" type="s:string" />
              <s:element minOccurs="0" maxOccurs="1" name="EspecPro4" type="s:string" />
              <s:element minOccurs="0" maxOccurs="1" name="EspecPro5" type="s:string" />
              <s:element minOccurs="0" maxOccurs="1" name="MultRecursos" type="s:string" />
              <s:element minOccurs="0" maxOccurs="1" name="UnidEnt" type="s:string" />
              <s:element minOccurs="0" maxOccurs="1" name="UnidSaida" type="s:string" />
              <s:element minOccurs="1" maxOccurs="1" name="MultUndEnt" type="s:double" />
              <s:element minOccurs="1" maxOccurs="1" name="MultUndSaida" type="s:double" />
              <s:element minOccurs="0" maxOccurs="1" name="TipoMulti" type="s:string" />
              <s:element minOccurs="1" maxOccurs="1" name="TipoConv" type="s:int" />
              <s:element minOccurs="1" maxOccurs="1" name="CodCentro" type="s:int" />
              <s:element minOccurs="1" maxOccurs="1" name="NaoDesfazEquipe" type="s:boolean" />
              <s:element minOccurs="0" maxOccurs="1" name="ImagemDir" type="s:string" />
              <s:element minOccurs="1" maxOccurs="1" name="Ordem" type="s:int" />
            </s:sequence>
          </s:extension>
        </s:complexContent>
      </s:complexType>
      <s:element name="carregarAvisosProducao">
        <s:complexType>
          <s:sequence>
            <s:element minOccurs="0" maxOccurs="1" name="token" type="tns:AccessToken" />
          </s:sequence>
        </s:complexType>
      </s:element>
      <s:element name="carregarAvisosProducaoResponse">
        <s:complexType>
          <s:sequence>
            <s:element minOccurs="0" maxOccurs="1" name="carregarAvisosProducaoResult" type="tns:ArrayOfAvisoDeProducaoVO" />
          </s:sequence>
        </s:complexType>
      </s:element>
      <s:complexType name="ArrayOfAvisoDeProducaoVO">
        <s:sequence>
          <s:element minOccurs="0" maxOccurs="unbounded" name="AvisoDeProducaoVO" nillable="true" type="tns:AvisoDeProducaoVO" />
        </s:sequence>
      </s:complexType>
      <s:complexType name="AvisoDeProducaoVO">
        <s:complexContent mixed="false">
          <s:extension base="tns:EcalcValueObject">
            <s:sequence>
              <s:element minOccurs="1" maxOccurs="1" name="ID" type="s:int" />
              <s:element minOccurs="1" maxOccurs="1" name="Data" type="s:dateTime" />
              <s:element minOccurs="0" maxOccurs="1" name="Usuario" type="s:string" />
              <s:element minOccurs="1" maxOccurs="1" name="Filial" type="s:int" />
              <s:element minOccurs="1" maxOccurs="1" name="Integra" type="s:boolean" />
              <s:element minOccurs="1" maxOccurs="1" name="Codregop" type="s:int" />
              <s:element minOccurs="1" maxOccurs="1" name="Integracao" type="s:int" />
              <s:element minOccurs="0" maxOccurs="1" name="Itens" type="tns:ArrayOfAvisoDeProducaoItemVO" />
            </s:sequence>
          </s:extension>
        </s:complexContent>
      </s:complexType>
      <s:complexType name="ArrayOfAvisoDeProducaoItemVO">
        <s:sequence>
          <s:element minOccurs="0" maxOccurs="unbounded" name="AvisoDeProducaoItemVO" nillable="true" type="tns:AvisoDeProducaoItemVO" />
        </s:sequence>
      </s:complexType>
      <s:complexType name="AvisoDeProducaoItemVO">
        <s:complexContent mixed="false">
          <s:extension base="tns:EcalcValueObject">
            <s:sequence>
              <s:element minOccurs="1" maxOccurs="1" name="ID" type="s:int" />
              <s:element minOccurs="1" maxOccurs="1" name="Codaviso" type="s:int" />
              <s:element minOccurs="1" maxOccurs="1" name="Quantidade" type="s:double" />
              <s:element minOccurs="1" maxOccurs="1" name="OS" type="s:int" />
              <s:element minOccurs="0" maxOccurs="1" name="CodProduto" type="s:string" />
              <s:element minOccurs="1" maxOccurs="1" name="CodseqComp" type="s:int" />
              <s:element minOccurs="1" maxOccurs="1" name="CustoUnitario" type="s:double" />
              <s:element minOccurs="1" maxOccurs="1" name="CustoTotal" type="s:double" />
              <s:element minOccurs="1" maxOccurs="1" name="Codkardex" type="s:int" />
              <s:element minOccurs="0" maxOccurs="1" name="Tipo" type="s:string" />
              <s:element minOccurs="1" maxOccurs="1" name="Pcustofixo" type="s:double" />
              <s:element minOccurs="1" maxOccurs="1" name="Finalizaos" type="s:boolean" />
              <s:element minOccurs="1" maxOccurs="1" name="Quantestoque" type="s:double" />
              <s:element minOccurs="1" maxOccurs="1" name="Quantidadeperdida" type="s:double" />
              <s:element minOccurs="1" maxOccurs="1" name="Expostatus" type="s:int" />
            </s:sequence>
          </s:extension>
        </s:complexContent>
      </s:complexType>
      <s:element name="carregarVendas">
        <s:complexType>
          <s:sequence>
            <s:element minOccurs="0" maxOccurs="1" name="token" type="tns:AccessToken" />
          </s:sequence>
        </s:complexType>
      </s:element>
      <s:element name="carregarVendasResponse">
        <s:complexType>
          <s:sequence>
            <s:element minOccurs="0" maxOccurs="1" name="carregarVendasResult" type="tns:ArrayOfVendaVO" />
          </s:sequence>
        </s:complexType>
      </s:element>
      <s:complexType name="ArrayOfVendaVO">
        <s:sequence>
          <s:element minOccurs="0" maxOccurs="unbounded" name="VendaVO" nillable="true" type="tns:VendaVO" />
        </s:sequence>
      </s:complexType>
      <s:complexType name="VendaVO">
        <s:complexContent mixed="false">
          <s:extension base="tns:EcalcValueObject">
            <s:sequence>
              <s:element minOccurs="1" maxOccurs="1" name="Codigo" type="s:int" />
              <s:element minOccurs="0" maxOccurs="1" name="Cref" type="s:string" />
              <s:element minOccurs="0" maxOccurs="1" name="CodCliente" type="s:string" />
              <s:element minOccurs="0" maxOccurs="1" name="Cliente" type="s:string" />
              <s:element minOccurs="0" maxOccurs="1" name="Munclie" type="s:string" />
              <s:element minOccurs="0" maxOccurs="1" name="Estclie" type="s:string" />
              <s:element minOccurs="0" maxOccurs="1" name="Cepclie" type="s:string" />
              <s:element minOccurs="1" maxOccurs="1" name="Saida" type="s:dateTime" />
              <s:element minOccurs="1" maxOccurs="1" name="Ccondpag" type="s:int" />
              <s:element minOccurs="0" maxOccurs="1" name="Condpag" type="s:string" />
              <s:element minOccurs="0" maxOccurs="1" name="FFrete" type="s:string" />
              <s:element minOccurs="1" maxOccurs="1" name="Frete" type="tns:TTipoFrete" />
              <s:element minOccurs="1" maxOccurs="1" name="Entrega" type="s:dateTime" />
              <s:element minOccurs="1" maxOccurs="1" name="Vtotal" type="s:double" />
              <s:element minOccurs="1" maxOccurs="1" name="Descnotapor" type="s:double" />
              <s:element minOccurs="1" maxOccurs="1" name="Vnota" type="s:double" />
              <s:element minOccurs="1" maxOccurs="1" name="Vtitulo" type="s:double" />
              <s:element minOccurs="0" maxOccurs="1" name="FStatus" type="s:string" />
              <s:element minOccurs="1" maxOccurs="1" name="Status" type="tns:TStatusVenda" />
              <s:element minOccurs="1" maxOccurs="1" name="Codindice" type="s:int" />
              <s:element minOccurs="0" maxOccurs="1" name="Indice" type="s:string" />
              <s:element minOccurs="0" maxOccurs="1" name="Codtransp" type="s:string" />
              <s:element minOccurs="0" maxOccurs="1" name="Transp" type="s:string" />
              <s:element minOccurs="0" maxOccurs="1" name="Codnatoper" type="s:string" />
              <s:element minOccurs="0" maxOccurs="1" name="Natoper" type="s:string" />
              <s:element minOccurs="0" maxOccurs="1" name="Nomenatop" type="s:string" />
              <s:element minOccurs="0" maxOccurs="1" name="Endclie" type="s:string" />
              <s:element minOccurs="0" maxOccurs="1" name="Razaoclie" type="s:string" />
              <s:element minOccurs="0" maxOccurs="1" name="Cliente2" type="s:string" />
              <s:element minOccurs="0" maxOccurs="1" name="Codcliente2" type="s:string" />
              <s:element minOccurs="0" maxOccurs="1" name="Muncli2" type="s:string" />
              <s:element minOccurs="0" maxOccurs="1" name="Estclie2" type="s:string" />
              <s:element minOccurs="0" maxOccurs="1" name="Cepcli2" type="s:string" />
              <s:element minOccurs="0" maxOccurs="1" name="Razaocli2" type="s:string" />
              <s:element minOccurs="0" maxOccurs="1" name="Proprietario" type="s:string" />
              <s:element minOccurs="1" maxOccurs="1" name="Codautonatoper" type="s:int" />
              <s:element minOccurs="1" maxOccurs="1" name="Codendcli" type="s:int" />
              <s:element minOccurs="1" maxOccurs="1" name="Formpag" type="s:int" />
              <s:element minOccurs="1" maxOccurs="1" name="Codendsac" type="s:int" />
              <s:element minOccurs="0" maxOccurs="1" name="Numclie" type="s:string" />
              <s:element minOccurs="1" maxOccurs="1" name="NumNota" type="s:int" />
              <s:element minOccurs="1" maxOccurs="1" name="PedidoID" type="s:int" />
              <s:element minOccurs="0" maxOccurs="1" name="CodExportacao" type="s:string" />
              <s:element minOccurs="1" maxOccurs="1" name="Integracao" type="s:int" />
              <s:element minOccurs="0" maxOccurs="1" name="Itens" type="tns:ArrayOfItemVendaVO" />
              <s:element minOccurs="0" maxOccurs="1" name="Produtos" type="tns:ArrayOfProdutoVendaVO" />
              <s:element minOccurs="0" maxOccurs="1" name="Servicos" type="tns:ArrayOfServicoVendaVO" />
            </s:sequence>
          </s:extension>
        </s:complexContent>
      </s:complexType>
      <s:simpleType name="TTipoFrete">
        <s:restriction base="s:string">
          <s:enumeration value="tIndefinido" />
          <s:enumeration value="tCIF" />
          <s:enumeration value="tFOB" />
          <s:enumeration value="tSemFrete" />
        </s:restriction>
      </s:simpleType>
      <s:complexType name="ArrayOfItemVendaVO">
        <s:sequence>
          <s:element minOccurs="0" maxOccurs="unbounded" name="ItemVendaVO" nillable="true" type="tns:ItemVendaVO" />
        </s:sequence>
      </s:complexType>
      <s:complexType name="ItemVendaVO">
        <s:complexContent mixed="false">
          <s:extension base="tns:EcalcValueObject">
            <s:sequence>
              <s:element minOccurs="1" maxOccurs="1" name="Codigo" type="s:int" />
              <s:element minOccurs="1" maxOccurs="1" name="Codordvend" type="s:int" />
              <s:element minOccurs="0" maxOccurs="1" name="Nomeitem" type="s:string" />
              <s:element minOccurs="0" maxOccurs="1" name="Coditem" type="s:string" />
              <s:element minOccurs="1" maxOccurs="1" name="Quantidade" type="s:double" />
              <s:element minOccurs="1" maxOccurs="1" name="Quantest" type="s:double" />
              <s:element minOccurs="1" maxOccurs="1" name="Punit" type="s:double" />
              <s:element minOccurs="1" maxOccurs="1" name="Ptotal" type="s:double" />
              <s:element minOccurs="1" maxOccurs="1" name="Ptotal2" type="s:double" />
              <s:element minOccurs="1" maxOccurs="1" name="Codunid" type="s:int" />
              <s:element minOccurs="1" maxOccurs="1" name="Cunidrep" type="s:int" />
              <s:element minOccurs="1" maxOccurs="1" name="Cunidest" type="s:int" />
              <s:element minOccurs="0" maxOccurs="1" name="Nomeunid" type="s:string" />
              <s:element minOccurs="0" maxOccurs="1" name="Nomeunidrep" type="s:string" />
              <s:element minOccurs="1" maxOccurs="1" name="Os" type="s:int" />
              <s:element minOccurs="1" maxOccurs="1" name="CodItemPed" type="s:int" />
            </s:sequence>
          </s:extension>
        </s:complexContent>
      </s:complexType>
      <s:complexType name="ArrayOfProdutoVendaVO">
        <s:sequence>
          <s:element minOccurs="0" maxOccurs="unbounded" name="ProdutoVendaVO" nillable="true" type="tns:ProdutoVendaVO" />
        </s:sequence>
      </s:complexType>
      <s:complexType name="ProdutoVendaVO">
        <s:complexContent mixed="false">
          <s:extension base="tns:EcalcValueObject">
            <s:sequence>
              <s:element minOccurs="1" maxOccurs="1" name="Codigo" type="s:int" />
              <s:element minOccurs="1" maxOccurs="1" name="Codordvend" type="s:int" />
              <s:element minOccurs="0" maxOccurs="1" name="Nomeitem" type="s:string" />
              <s:element minOccurs="0" maxOccurs="1" name="Coditem" type="s:string" />
              <s:element minOccurs="1" maxOccurs="1" name="Quantidade" type="s:double" />
              <s:element minOccurs="1" maxOccurs="1" name="Quantest" type="s:double" />
              <s:element minOccurs="1" maxOccurs="1" name="Punit" type="s:double" />
              <s:element minOccurs="1" maxOccurs="1" name="Ptotal" type="s:double" />
              <s:element minOccurs="1" maxOccurs="1" name="Ptotal2" type="s:double" />
              <s:element minOccurs="1" maxOccurs="1" name="Cunidade" type="s:int" />
              <s:element minOccurs="1" maxOccurs="1" name="Cunidvend" type="s:int" />
              <s:element minOccurs="0" maxOccurs="1" name="Nomeunid" type="s:string" />
              <s:element minOccurs="0" maxOccurs="1" name="Nomeunidvend" type="s:string" />
              <s:element minOccurs="1" maxOccurs="1" name="Os" type="s:int" />
            </s:sequence>
          </s:extension>
        </s:complexContent>
      </s:complexType>
      <s:complexType name="ArrayOfServicoVendaVO">
        <s:sequence>
          <s:element minOccurs="0" maxOccurs="unbounded" name="ServicoVendaVO" nillable="true" type="tns:ServicoVendaVO" />
        </s:sequence>
      </s:complexType>
      <s:complexType name="ServicoVendaVO">
        <s:complexContent mixed="false">
          <s:extension base="tns:EcalcValueObject">
            <s:sequence>
              <s:element minOccurs="1" maxOccurs="1" name="Codigo" type="s:int" />
              <s:element minOccurs="1" maxOccurs="1" name="Codordvend" type="s:int" />
              <s:element minOccurs="0" maxOccurs="1" name="Nomeserv" type="s:string" />
              <s:element minOccurs="1" maxOccurs="1" name="Punit" type="s:double" />
              <s:element minOccurs="1" maxOccurs="1" name="Ptotal" type="s:double" />
              <s:element minOccurs="1" maxOccurs="1" name="Quantidade" type="s:double" />
              <s:element minOccurs="1" maxOccurs="1" name="Quantest" type="s:double" />
              <s:element minOccurs="1" maxOccurs="1" name="Codunid" type="s:int" />
              <s:element minOccurs="0" maxOccurs="1" name="Cunidade" type="s:string" />
              <s:element minOccurs="0" maxOccurs="1" name="Nomeunid" type="s:string" />
              <s:element minOccurs="1" maxOccurs="1" name="Os" type="s:int" />
            </s:sequence>
          </s:extension>
        </s:complexContent>
      </s:complexType>
      <s:element name="carregarMateriaisOS">
        <s:complexType>
          <s:sequence>
            <s:element minOccurs="0" maxOccurs="1" name="token" type="tns:AccessToken" />
          </s:sequence>
        </s:complexType>
      </s:element>
      <s:element name="carregarMateriaisOSResponse">
        <s:complexType>
          <s:sequence>
            <s:element minOccurs="0" maxOccurs="1" name="carregarMateriaisOSResult" type="tns:ArrayOfMatOSVO" />
          </s:sequence>
        </s:complexType>
      </s:element>
      <s:complexType name="ArrayOfMatOSVO">
        <s:sequence>
          <s:element minOccurs="0" maxOccurs="unbounded" name="MatOSVO" nillable="true" type="tns:MatOSVO" />
        </s:sequence>
      </s:complexType>
      <s:complexType name="MatOSVO">
        <s:complexContent mixed="false">
          <s:extension base="tns:EcalcValueObject">
            <s:sequence>
              <s:element minOccurs="1" maxOccurs="1" name="ID" type="s:int" />
              <s:element minOccurs="1" maxOccurs="1" name="Cnpo" type="s:int" />
              <s:element minOccurs="1" maxOccurs="1" name="Plano" type="s:int" />
              <s:element minOccurs="0" maxOccurs="1" name="Coditem" type="s:string" />
              <s:element minOccurs="0" maxOccurs="1" name="CodItemAnterior" type="s:string" />
              <s:element minOccurs="1" maxOccurs="1" name="Quantidade" type="s:double" />
              <s:element minOccurs="1" maxOccurs="1" name="Custo" type="s:double" />
              <s:element minOccurs="1" maxOccurs="1" name="Eorca" type="s:boolean" />
              <s:element minOccurs="1" maxOccurs="1" name="Empresa" type="s:int" />
              <s:element minOccurs="1" maxOccurs="1" name="Datamod" type="s:dateTime" />
              <s:element minOccurs="1" maxOccurs="1" name="Integracao" type="s:int" />
            </s:sequence>
          </s:extension>
        </s:complexContent>
      </s:complexType>
      <s:element name="carregarApontamentos">
        <s:complexType>
          <s:sequence>
            <s:element minOccurs="0" maxOccurs="1" name="token" type="tns:AccessToken" />
          </s:sequence>
        </s:complexType>
      </s:element>
      <s:element name="carregarApontamentosResponse">
        <s:complexType>
          <s:sequence>
            <s:element minOccurs="0" maxOccurs="1" name="carregarApontamentosResult" type="tns:ArrayOfRegistroOperacaoVO" />
          </s:sequence>
        </s:complexType>
      </s:element>
      <s:complexType name="ArrayOfRegistroOperacaoVO">
        <s:sequence>
          <s:element minOccurs="0" maxOccurs="unbounded" name="RegistroOperacaoVO" nillable="true" type="tns:RegistroOperacaoVO" />
        </s:sequence>
      </s:complexType>
      <s:complexType name="RegistroOperacaoVO">
        <s:complexContent mixed="false">
          <s:extension base="tns:EcalcValueObject">
            <s:sequence>
              <s:element minOccurs="1" maxOccurs="1" name="ID" type="s:int" />
              <s:element minOccurs="1" maxOccurs="1" name="ProcessoID" type="s:int" />
              <s:element minOccurs="1" maxOccurs="1" name="Inicio" type="s:dateTime" />
              <s:element minOccurs="1" maxOccurs="1" name="Fim" type="s:dateTime" />
              <s:element minOccurs="1" maxOccurs="1" name="EventoID" type="s:int" />
              <s:element minOccurs="1" maxOccurs="1" name="MaquinaID" type="s:int" />
              <s:element minOccurs="1" maxOccurs="1" name="QuantidadeRecebida" type="s:double" />
              <s:element minOccurs="1" maxOccurs="1" name="FatorRecebido" type="s:double" />
              <s:element minOccurs="0" maxOccurs="1" name="UnidadeRecebida" type="s:string" />
              <s:element minOccurs="1" maxOccurs="1" name="Quantrecun" type="s:double" />
              <s:element minOccurs="1" maxOccurs="1" name="QuantidadeEntregue" type="s:double" />
              <s:element minOccurs="1" maxOccurs="1" name="FatorEntregue" type="s:double" />
              <s:element minOccurs="0" maxOccurs="1" name="UnidadeEntregue" type="s:string" />
              <s:element minOccurs="1" maxOccurs="1" name="Quantentun" type="s:double" />
              <s:element minOccurs="1" maxOccurs="1" name="Perda" type="s:double" />
              <s:element minOccurs="1" maxOccurs="1" name="TotalProduzido" type="s:double" />
              <s:element minOccurs="0" maxOccurs="1" name="Obs" type="s:string" />
              <s:element minOccurs="1" maxOccurs="1" name="OS" type="s:int" />
              <s:element minOccurs="0" maxOccurs="1" name="OperadorID" type="s:string" />
              <s:element minOccurs="1" maxOccurs="1" name="HoraExtra" type="s:int" />
              <s:element minOccurs="1" maxOccurs="1" name="Plano" type="s:int" />
              <s:element minOccurs="1" maxOccurs="1" name="TipoProcesso" type="s:int" />
              <s:element minOccurs="1" maxOccurs="1" name="Equipe" type="s:boolean" />
              <s:element minOccurs="1" maxOccurs="1" name="RegopEquipe" type="s:int" />
              <s:element minOccurs="0" maxOccurs="1" name="Justificativa" type="s:string" />
              <s:element minOccurs="1" maxOccurs="1" name="Completed" type="s:boolean" />
              <s:element minOccurs="1" maxOccurs="1" name="SubstituicaoPerda" type="s:int" />
              <s:element minOccurs="1" maxOccurs="1" name="Integracao" type="s:int" />
              <s:element minOccurs="1" maxOccurs="1" name="ProcessoOrigemPerda" nillable="true" type="s:int" />
              <s:element minOccurs="0" maxOccurs="1" name="EventoNome" type="s:string" />
              <s:element minOccurs="0" maxOccurs="1" name="ReferenciaPlano" type="s:string" />
              <s:element minOccurs="0" maxOccurs="1" name="NumAno" type="s:string" />
              <s:element minOccurs="0" maxOccurs="1" name="NomeOperador" type="s:string" />
              <s:element minOccurs="0" maxOccurs="1" name="Evento" type="tns:EventoVO" />
              <s:element minOccurs="0" maxOccurs="1" name="Operador" type="tns:OperadorVO" />
              <s:element minOccurs="0" maxOccurs="1" name="Processo" type="tns:ProcessoVO" />
              <s:element minOccurs="0" maxOccurs="1" name="justificativa" type="tns:JustificativaVO" />
            </s:sequence>
          </s:extension>
        </s:complexContent>
      </s:complexType>
      <s:complexType name="EventoVO">
        <s:complexContent mixed="false">
          <s:extension base="tns:EcalcValueObject">
            <s:sequence>
              <s:element minOccurs="1" maxOccurs="1" name="ID" type="s:int" />
              <s:element minOccurs="0" maxOccurs="1" name="Nome" type="s:string" />
              <s:element minOccurs="1" maxOccurs="1" name="Prod" type="tns:TipoProd" />
              <s:element minOccurs="1" maxOccurs="1" name="NaoVinculaOS" type="s:boolean" />
              <s:element minOccurs="1" maxOccurs="1" name="ObservacaoObrigatoria" type="s:boolean" />
              <s:element minOccurs="1" maxOccurs="1" name="Codigo" type="s:int" />
              <s:element minOccurs="1" maxOccurs="1" name="Desativado" type="s:boolean" />
              <s:element minOccurs="1" maxOccurs="1" name="PermitirFinalizar" type="s:boolean" />
              <s:element minOccurs="1" maxOccurs="1" name="PermitirTrocarOS" type="s:boolean" />
              <s:element minOccurs="1" maxOccurs="1" name="Cor" type="s:int" />
              <s:element minOccurs="1" maxOccurs="1" name="TempoApontamento" type="s:int" />
              <s:element minOccurs="1" maxOccurs="1" name="AlertaApontamento" type="s:int" />
              <s:element minOccurs="0" maxOccurs="1" name="StatusJMF" type="s:string" />
              <s:element minOccurs="1" maxOccurs="1" name="NaoMudarParaProducaoAutomatica" type="s:boolean" />
              <s:element minOccurs="1" maxOccurs="1" name="NaoMudarParaParadaAutomatica" type="s:boolean" />
            </s:sequence>
          </s:extension>
        </s:complexContent>
      </s:complexType>
      <s:simpleType name="TipoProd">
        <s:restriction base="s:string">
          <s:enumeration value="parada" />
          <s:enumeration value="producao" />
          <s:enumeration value="acerto" />
          <s:enumeration value="ocioso" />
        </s:restriction>
      </s:simpleType>
      <s:complexType name="OperadorVO">
        <s:complexContent mixed="false">
          <s:extension base="tns:EcalcValueObject">
            <s:sequence>
              <s:element minOccurs="1" maxOccurs="1" name="ID" type="s:int" />
              <s:element minOccurs="0" maxOccurs="1" name="Codigo" type="s:string" />
              <s:element minOccurs="0" maxOccurs="1" name="Nome" type="s:string" />
              <s:element minOccurs="0" maxOccurs="1" name="Senha" type="s:string" />
              <s:element minOccurs="1" maxOccurs="1" name="CustoHora" type="s:double" />
              <s:element minOccurs="1" maxOccurs="1" name="MaquinaPreferencial" type="s:int" />
              <s:element minOccurs="1" maxOccurs="1" name="NaoPedeSenha" type="s:boolean" />
              <s:element minOccurs="1" maxOccurs="1" name="Ativo" type="s:boolean" />
              <s:element minOccurs="1" maxOccurs="1" name="NaoPermiteFinalizarApontDeOutroOperador" type="s:boolean" />
              <s:element minOccurs="0" maxOccurs="1" name="CodExportacao" type="s:string" />
              <s:element minOccurs="0" maxOccurs="1" name="PermissaoParaTrazerTarefa" type="s:string" />
              <s:element minOccurs="1" maxOccurs="1" name="FormaEquipe" type="s:boolean" />
              <s:element minOccurs="1" maxOccurs="1" name="BaixaEstoque" type="s:boolean" />
              <s:element minOccurs="1" maxOccurs="1" name="PermiteFinalizarProcessosAntecessores" type="s:boolean" />
              <s:element minOccurs="1" maxOccurs="1" name="NaoMostraAcertoEPerda" type="s:boolean" />
              <s:element minOccurs="1" maxOccurs="1" name="NaoMostraBotaoFinalizar" type="s:boolean" />
              <s:element minOccurs="1" maxOccurs="1" name="NaoMostraBotaoAcerto" type="s:boolean" />
              <s:element minOccurs="1" maxOccurs="1" name="NaoMostraBotaoAjustarPerda" type="s:boolean" />
              <s:element minOccurs="1" maxOccurs="1" name="PermiteDevolverEstoqueLocal" type="s:boolean" />
              <s:element minOccurs="1" maxOccurs="1" name="PermiteApontamentoSimultaneo" type="s:boolean" />
            </s:sequence>
          </s:extension>
        </s:complexContent>
      </s:complexType>
      <s:complexType name="ProcessoVO">
        <s:complexContent mixed="false">
          <s:extension base="tns:EcalcValueObject">
            <s:sequence>
              <s:element minOccurs="0" maxOccurs="1" name="OS" type="tns:OrdemDeServicoVO" />
              <s:element minOccurs="0" maxOccurs="1" name="planoOS" type="tns:PlanoProgramacaoVO" />
              <s:element minOccurs="0" maxOccurs="1" name="Maquina" type="tns:MaquinaVO" />
              <s:element minOccurs="0" maxOccurs="1" name="Dependencias" type="tns:ArrayOfProcessoDependenciaVO" />
              <s:element minOccurs="0" maxOccurs="1" name="DependenciasInversas" type="tns:ArrayOfProcessoDependenciaVO" />
              <s:element minOccurs="1" maxOccurs="1" name="ID" type="s:int" />
              <s:element minOccurs="1" maxOccurs="1" name="CNPO" type="s:int" />
              <s:element minOccurs="1" maxOccurs="1" name="Plano" type="s:int" />
              <s:element minOccurs="0" maxOccurs="1" name="Referencia" type="s:string" />
              <s:element minOccurs="1" maxOccurs="1" name="Quantidade" type="s:double" />
              <s:element minOccurs="1" maxOccurs="1" name="TempoProducao" type="s:double" />
              <s:element minOccurs="1" maxOccurs="1" name="TempoProducaoOriginal" type="s:double" />
              <s:element minOccurs="1" maxOccurs="1" name="TempoAcerto" type="s:double" />
              <s:element minOccurs="1" maxOccurs="1" name="MaquinaID" type="s:int" />
              <s:element minOccurs="1" maxOccurs="1" name="Inicio" type="s:dateTime" />
              <s:element minOccurs="1" maxOccurs="1" name="InicioOriginal" nillable="true" type="s:dateTime" />
              <s:element minOccurs="1" maxOccurs="1" name="Termino" type="s:dateTime" />
              <s:element minOccurs="1" maxOccurs="1" name="Restricao" nillable="true" type="s:dateTime" />
              <s:element minOccurs="1" maxOccurs="1" name="Datalib" type="s:dateTime" />
              <s:element minOccurs="1" maxOccurs="1" name="PercentualLiberado" type="s:double" />
              <s:element minOccurs="1" maxOccurs="1" name="Concluido" type="s:double" />
              <s:element minOccurs="1" maxOccurs="1" name="PercentualAcerto" type="s:double" />
              <s:element minOccurs="1" maxOccurs="1" name="Terminado" type="s:boolean" />
              <s:element minOccurs="1" maxOccurs="1" name="NumRecursos" type="s:int" />
              <s:element minOccurs="1" maxOccurs="1" name="Prioridade" type="s:int" />
              <s:element minOccurs="1" maxOccurs="1" name="CodseqTab" type="s:int" />
              <s:element minOccurs="1" maxOccurs="1" name="TipoProc" type="s:int" />
              <s:element minOccurs="1" maxOccurs="1" name="Quantinic" type="s:double" />
              <s:element minOccurs="1" maxOccurs="1" name="PendenteDeAprovacaoCliente" type="s:boolean" />
              <s:element minOccurs="1" maxOccurs="1" name="Cenario" type="s:int" />
              <s:element minOccurs="1" maxOccurs="1" name="Sequencia" type="s:int" />
              <s:element minOccurs="1" maxOccurs="1" name="HoraCritica" nillable="true" type="s:dateTime" />
              <s:element minOccurs="1" maxOccurs="1" name="TerminoCritico" nillable="true" type="s:dateTime" />
              <s:element minOccurs="1" maxOccurs="1" name="SemanaAno" type="s:int" />
              <s:element minOccurs="1" maxOccurs="1" name="GerouJDF" type="s:boolean" />
              <s:element minOccurs="1" maxOccurs="1" name="QuantidadeOriginal" type="s:double" />
              <s:element minOccurs="1" maxOccurs="1" name="Responsavel" type="s:int" />
              <s:element minOccurs="1" maxOccurs="1" name="NumPlanoSemelhante" type="s:int" />
              <s:element minOccurs="1" maxOccurs="1" name="PlanoSemelhante" type="s:int" />
              <s:element minOccurs="1" maxOccurs="1" name="AlteracaoOS" type="s:boolean" />
              <s:element minOccurs="1" maxOccurs="1" name="JuntouFrenteEVerso" type="s:boolean" />
              <s:element minOccurs="0" maxOccurs="1" name="Observacoes" type="s:string" />
              <s:element minOccurs="1" maxOccurs="1" name="Fixado" type="s:boolean" />
              <s:element minOccurs="1" maxOccurs="1" name="InseridoManualmente" type="s:boolean" />
              <s:element minOccurs="1" maxOccurs="1" name="QuantidadeMalaLocal" type="s:double" />
              <s:element minOccurs="1" maxOccurs="1" name="QuantidadePerdaLocal" type="s:double" />
              <s:element minOccurs="1" maxOccurs="1" name="PreImpressao" type="s:boolean" />
              <s:element minOccurs="1" maxOccurs="1" name="Multiplicador" type="s:int" />
              <s:element minOccurs="1" maxOccurs="1" name="CodEntrega" type="s:int" />
              <s:element minOccurs="1" maxOccurs="1" name="TiragemSaida" type="s:double" />
              <s:element minOccurs="1" maxOccurs="1" name="CodImpressao" type="s:int" />
              <s:element minOccurs="1" maxOccurs="1" name="Desativado" type="s:boolean" />
              <s:element minOccurs="0" maxOccurs="1" name="Cliente" type="s:string" />
              <s:element minOccurs="0" maxOccurs="1" name="ReferenciaOS" type="s:string" />
              <s:element minOccurs="0" maxOccurs="1" name="ReferenciaPlano" type="s:string" />
            </s:sequence>
          </s:extension>
        </s:complexContent>
      </s:complexType>
      <s:complexType name="OrdemDeServicoVO">
        <s:complexContent mixed="false">
          <s:extension base="tns:CalculoBaseVO">
            <s:sequence>
              <s:element minOccurs="1" maxOccurs="1" name="ID" type="s:int" />
              <s:element minOccurs="0" maxOccurs="1" name="NumAno" type="s:string" />
              <s:element minOccurs="0" maxOccurs="1" name="Cliente" type="s:string" />
              <s:element minOccurs="1" maxOccurs="1" name="Posicaoos" type="tns:PosicaoOS" />
              <s:element minOccurs="1" maxOccurs="1" name="Terminado" type="s:boolean" />
              <s:element minOccurs="1" maxOccurs="1" name="Usuariofimos" type="s:int" />
              <s:element minOccurs="1" maxOccurs="1" name="Dataencerrapcp" type="s:dateTime" />
              <s:element minOccurs="1" maxOccurs="1" name="Orcagera" type="s:int" />
              <s:element minOccurs="1" maxOccurs="1" name="Data" type="s:dateTime" />
              <s:element minOccurs="0" maxOccurs="1" name="Referencia" type="s:string" />
              <s:element minOccurs="0" maxOccurs="1" name="TipoServico" type="s:string" />
              <s:element minOccurs="1" maxOccurs="1" name="CNPO" type="s:int" />
              <s:element minOccurs="1" maxOccurs="1" name="GeraOS" type="s:int" />
              <s:element minOccurs="0" maxOccurs="1" name="CodCliente" type="s:string" />
              <s:element minOccurs="1" maxOccurs="1" name="PrecoPorMil" type="s:double" />
              <s:element minOccurs="1" maxOccurs="1" name="Quantidade" type="s:int" />
              <s:element minOccurs="1" maxOccurs="1" name="DescontoPercentPre" type="s:decimal" />
              <s:element minOccurs="1" maxOccurs="1" name="DescontoPercentGrafica" type="s:decimal" />
              <s:element minOccurs="1" maxOccurs="1" name="FormaFinal1" type="s:double" />
              <s:element minOccurs="1" maxOccurs="1" name="FormaFinal2" type="s:double" />
              <s:element minOccurs="1" maxOccurs="1" name="FormaFinal3" type="s:double" />
              <s:element minOccurs="1" maxOccurs="1" name="CdsPec1" type="s:int" />
              <s:element minOccurs="1" maxOccurs="1" name="CdsPec2" type="s:int" />
              <s:element minOccurs="1" maxOccurs="1" name="CdsPec3" type="s:int" />
              <s:element minOccurs="1" maxOccurs="1" name="CustoConvertido" type="s:double" />
              <s:element minOccurs="1" maxOccurs="1" name="ValorCustoTerceiro" type="s:double" />
              <s:element minOccurs="1" maxOccurs="1" name="ValorCustoMaterial" type="s:double" />
              <s:element minOccurs="1" maxOccurs="1" name="ValorLucro" type="s:double" />
              <s:element minOccurs="1" maxOccurs="1" name="ValorCustoDiretoVenda" type="s:double" />
              <s:element minOccurs="1" maxOccurs="1" name="PorcentagemLucro" type="s:double" />
              <s:element minOccurs="1" maxOccurs="1" name="PorcentagemCustoDiretoVenda" type="s:double" />
              <s:element minOccurs="1" maxOccurs="1" name="ValorMargemContribuicao" type="s:double" />
              <s:element minOccurs="1" maxOccurs="1" name="PorCentMargemContribuicao" type="s:double" />
              <s:element minOccurs="1" maxOccurs="1" name="Status" type="s:int" />
              <s:element minOccurs="0" maxOccurs="1" name="CodExportacao" type="s:string" />
              <s:element minOccurs="1" maxOccurs="1" name="DataEntrega" type="s:dateTime" />
              <s:element minOccurs="0" maxOccurs="1" name="Obs" type="s:string" />
              <s:element minOccurs="1" maxOccurs="1" name="DataUltimaAlteracao" type="s:dateTime" />
              <s:element minOccurs="1" maxOccurs="1" name="CondicaoPagamentoID" type="s:int" />
              <s:element minOccurs="0" maxOccurs="1" name="CodVendedor1" type="s:string" />
              <s:element minOccurs="0" maxOccurs="1" name="CodVendedor2" type="s:string" />
              <s:element minOccurs="0" maxOccurs="1" name="CodVendedor3" type="s:string" />
              <s:element minOccurs="0" maxOccurs="1" name="CodVendedor4" type="s:string" />
              <s:element minOccurs="1" maxOccurs="1" name="ValorComissaoVendedor1" type="s:double" />
              <s:element minOccurs="1" maxOccurs="1" name="ValorComissaoVendedor2" type="s:double" />
              <s:element minOccurs="1" maxOccurs="1" name="ValorComissaoVendedor3" type="s:double" />
              <s:element minOccurs="1" maxOccurs="1" name="ValorComissaoVendedor4" type="s:double" />
              <s:element minOccurs="1" maxOccurs="1" name="PercentualComissaoVendedor1" type="s:double" />
              <s:element minOccurs="1" maxOccurs="1" name="PercentualComissaoVendedor2" type="s:double" />
              <s:element minOccurs="1" maxOccurs="1" name="PercentualComissaoVendedor3" type="s:double" />
              <s:element minOccurs="1" maxOccurs="1" name="PercentualComissaoVendedor4" type="s:double" />
              <s:element minOccurs="1" maxOccurs="1" name="ExportacaoStatus" type="s:int" />
              <s:element minOccurs="1" maxOccurs="1" name="Integracao" type="s:int" />
              <s:element minOccurs="1" maxOccurs="1" name="PesoLiquidoUnitario" type="s:double" />
              <s:element minOccurs="1" maxOccurs="1" name="Prazo" type="s:dateTime" />
            </s:sequence>
          </s:extension>
        </s:complexContent>
      </s:complexType>
      <s:complexType name="CalculoBaseVO" abstract="true">
        <s:complexContent mixed="false">
          <s:extension base="tns:EcalcValueObject">
            <s:sequence>
              <s:element minOccurs="1" maxOccurs="1" name="TipoDeServico" type="s:int" />
              <s:element minOccurs="1" maxOccurs="1" name="Empresa" type="s:int" />
              <s:element minOccurs="1" maxOccurs="1" name="PrecoFinal" type="s:decimal" />
              <s:element minOccurs="1" maxOccurs="1" name="PrecoUnitario" type="s:decimal" />
              <s:element minOccurs="1" maxOccurs="1" name="CustoConversao" type="s:decimal" />
              <s:element minOccurs="1" maxOccurs="1" name="CustoMaterial" type="s:decimal" />
              <s:element minOccurs="1" maxOccurs="1" name="CustoServicoTerceiro" type="s:decimal" />
              <s:element minOccurs="1" maxOccurs="1" name="CDVPercentualImposto" type="s:decimal" />
              <s:element minOccurs="1" maxOccurs="1" name="CDVPercentualJuros" type="s:decimal" />
              <s:element minOccurs="1" maxOccurs="1" name="CDVPercentualContribuicoes" type="s:decimal" />
              <s:element minOccurs="1" maxOccurs="1" name="CDVPercentualComissaoVendedor1" type="s:decimal" />
              <s:element minOccurs="1" maxOccurs="1" name="CDVPercentualComissaoVendedor2" type="s:decimal" />
              <s:element minOccurs="1" maxOccurs="1" name="CDVPercentualComissaoVendedor3" type="s:decimal" />
              <s:element minOccurs="1" maxOccurs="1" name="CDVPercentualComissaoVendedor4" type="s:decimal" />
              <s:element minOccurs="1" maxOccurs="1" name="MargemContribuicaoPercentual" type="s:decimal" />
              <s:element minOccurs="1" maxOccurs="1" name="MargemContribuicaoValor" type="s:decimal" />
              <s:element minOccurs="1" maxOccurs="1" name="LucroPercentual" type="s:decimal" />
              <s:element minOccurs="1" maxOccurs="1" name="LucroValor" type="s:decimal" />
            </s:sequence>
          </s:extension>
        </s:complexContent>
      </s:complexType>
      <s:simpleType name="PosicaoOS">
        <s:restriction base="s:string">
          <s:enumeration value="NaoProgramada" />
          <s:enumeration value="Programada" />
          <s:enumeration value="Encerrada" />
        </s:restriction>
      </s:simpleType>
      <s:complexType name="PlanoProgramacaoVO">
        <s:complexContent mixed="false">
          <s:extension base="tns:EcalcValueObject">
            <s:sequence>
              <s:element minOccurs="1" maxOccurs="1" name="ID" type="s:int" />
              <s:element minOccurs="1" maxOccurs="1" name="Plano" type="s:int" />
              <s:element minOccurs="1" maxOccurs="1" name="CNPO" type="s:int" />
              <s:element minOccurs="0" maxOccurs="1" name="ReferenciaPlano" type="s:string" />
              <s:element minOccurs="1" maxOccurs="1" name="Empresa" type="s:int" />
              <s:element minOccurs="1" maxOccurs="1" name="MontagemCadernoX" type="s:int" />
              <s:element minOccurs="1" maxOccurs="1" name="MontagemCadernoY" type="s:int" />
              <s:element minOccurs="1" maxOccurs="1" name="CadOriginalX" type="s:double" />
              <s:element minOccurs="1" maxOccurs="1" name="CadOriginalY" type="s:double" />
              <s:element minOccurs="1" maxOccurs="1" name="CoresFrente" type="s:int" />
              <s:element minOccurs="1" maxOccurs="1" name="CoresVerso" type="s:int" />
              <s:element minOccurs="1" maxOccurs="1" name="empe" type="s:boolean" />
              <s:element minOccurs="1" maxOccurs="1" name="InverteuImpressao" type="s:boolean" />
              <s:element minOccurs="1" maxOccurs="1" name="Montagem1X" type="s:int" />
              <s:element minOccurs="1" maxOccurs="1" name="Montagem2X" type="s:int" />
              <s:element minOccurs="1" maxOccurs="1" name="Montagem1Y" type="s:int" />
              <s:element minOccurs="1" maxOccurs="1" name="Montagem2Y" type="s:int" />
              <s:element minOccurs="1" maxOccurs="1" name="MontagemX" type="s:int" />
              <s:element minOccurs="1" maxOccurs="1" name="MontagemY" type="s:int" />
              <s:element minOccurs="1" maxOccurs="1" name="NormPapelX" type="s:int" />
              <s:element minOccurs="1" maxOccurs="1" name="NormPapelY" type="s:int" />
              <s:element minOccurs="1" maxOccurs="1" name="FormatoOriginalX" type="s:double" />
              <s:element minOccurs="1" maxOccurs="1" name="FormatoOriginalY" type="s:double" />
              <s:element minOccurs="1" maxOccurs="1" name="PapelX" type="s:double" />
              <s:element minOccurs="1" maxOccurs="1" name="PapelY" type="s:double" />
              <s:element minOccurs="1" maxOccurs="1" name="PlanoSemelhantes" type="s:int" />
              <s:element minOccurs="1" maxOccurs="1" name="TamXPlano" type="s:double" />
              <s:element minOccurs="1" maxOccurs="1" name="TamYPlano" type="s:double" />
              <s:element minOccurs="1" maxOccurs="1" name="MargemSangriaX" type="s:double" />
              <s:element minOccurs="1" maxOccurs="1" name="MargemSangriaY" type="s:double" />
              <s:element minOccurs="1" maxOccurs="1" name="EspacoImagemX" type="s:double" />
              <s:element minOccurs="1" maxOccurs="1" name="EspacoImagemY" type="s:double" />
              <s:element minOccurs="1" maxOccurs="1" name="RefilePapel" type="s:double" />
              <s:element minOccurs="1" maxOccurs="1" name="GramaturaPapel" type="s:double" />
              <s:element minOccurs="1" maxOccurs="1" name="Alceado" type="s:boolean" />
              <s:element minOccurs="0" maxOccurs="1" name="NumeracaoCadernos" type="s:string" />
              <s:element minOccurs="0" maxOccurs="1" name="NumeracaoCadernosList" type="tns:ArrayOfInt" />
              <s:element minOccurs="1" maxOccurs="1" name="CadernosParalelos" type="s:int" />
              <s:element minOccurs="1" maxOccurs="1" name="MultiplicadorDobra" type="s:int" />
              <s:element minOccurs="1" maxOccurs="1" name="TotalCadernos" type="s:int" />
              <s:element minOccurs="1" maxOccurs="1" name="CadernosDiferenteJuntos" type="s:int" />
            </s:sequence>
          </s:extension>
        </s:complexContent>
      </s:complexType>
      <s:complexType name="ArrayOfProcessoDependenciaVO">
        <s:sequence>
          <s:element minOccurs="0" maxOccurs="unbounded" name="ProcessoDependenciaVO" nillable="true" type="tns:ProcessoDependenciaVO" />
        </s:sequence>
      </s:complexType>
      <s:complexType name="ProcessoDependenciaVO">
        <s:complexContent mixed="false">
          <s:extension base="tns:EcalcValueObject">
            <s:sequence>
              <s:element minOccurs="1" maxOccurs="1" name="ID" type="s:int" />
              <s:element minOccurs="1" maxOccurs="1" name="ProcessoID" type="s:int" />
              <s:element minOccurs="1" maxOccurs="1" name="ProcessoDependenciaID" type="s:int" />
              <s:element minOccurs="1" maxOccurs="1" name="TipoRestricao" type="tns:TipoRestricao" />
              <s:element minOccurs="1" maxOccurs="1" name="DataRestricao" type="s:dateTime" />
              <s:element minOccurs="0" maxOccurs="1" name="Descricao" type="s:string" />
              <s:element minOccurs="1" maxOccurs="1" name="AplicarRestricaoQuantidade" type="tns:TipoAplicavel" />
              <s:element minOccurs="1" maxOccurs="1" name="AplicaRestricaoTempo" type="tns:TipoAplicavel" />
              <s:element minOccurs="1" maxOccurs="1" name="RestricaoTempo" type="s:double" />
              <s:element minOccurs="1" maxOccurs="1" name="RestricaoQuantidade" type="s:double" />
              <s:element minOccurs="1" maxOccurs="1" name="QuantPorcentagem" type="s:int" />
              <s:element minOccurs="0" maxOccurs="1" name="OBS" type="s:string" />
              <s:element minOccurs="1" maxOccurs="1" name="Critico" type="s:boolean" />
              <s:element minOccurs="1" maxOccurs="1" name="CriticoData" type="s:dateTime" />
              <s:element minOccurs="1" maxOccurs="1" name="Concluido" type="s:boolean" />
              <s:element minOccurs="1" maxOccurs="1" name="ConcluidoData" type="s:dateTime" />
              <s:element minOccurs="0" maxOccurs="1" name="CodFornecedor" type="s:string" />
              <s:element minOccurs="1" maxOccurs="1" name="TipoRestricaoExterna" type="s:int" />
              <s:element minOccurs="1" maxOccurs="1" name="UsuarioResponsavel" type="s:int" />
              <s:element minOccurs="0" maxOccurs="1" name="Processo" type="tns:ProcessoVO" />
              <s:element minOccurs="1" maxOccurs="1" name="ProcSequencia" type="s:long" />
              <s:element minOccurs="1" maxOccurs="1" name="Plano" type="s:int" />
              <s:element minOccurs="0" maxOccurs="1" name="NomePlano" type="s:string" />
              <s:element minOccurs="1" maxOccurs="1" name="QuantProcesso" type="s:double" />
              <s:element minOccurs="0" maxOccurs="1" name="NumeroOS" type="s:string" />
              <s:element minOccurs="0" maxOccurs="1" name="MaquinaProcesso" type="s:string" />
              <s:element minOccurs="0" maxOccurs="1" name="ProcessoDependencia" type="tns:ProcessoVO" />
              <s:element minOccurs="1" maxOccurs="1" name="IDOriginal" type="s:int" />
            </s:sequence>
          </s:extension>
        </s:complexContent>
      </s:complexType>
      <s:simpleType name="TipoRestricao">
        <s:restriction base="s:string">
          <s:enumeration value="Indefinido" />
          <s:enumeration value="Interna" />
          <s:enumeration value="Externa" />
        </s:restriction>
      </s:simpleType>
      <s:simpleType name="TipoAplicavel">
        <s:restriction base="s:string">
          <s:enumeration value="Inativo" />
          <s:enumeration value="Inicio" />
          <s:enumeration value="Termino" />
        </s:restriction>
      </s:simpleType>
      <s:complexType name="JustificativaVO">
        <s:complexContent mixed="false">
          <s:extension base="tns:EcalcValueObject">
            <s:sequence>
              <s:element minOccurs="1" maxOccurs="1" name="ID" type="s:int" />
              <s:element minOccurs="0" maxOccurs="1" name="Justificativa" type="s:string" />
              <s:element minOccurs="1" maxOccurs="1" name="Tipo" type="tns:TipoJustificativa" />
            </s:sequence>
          </s:extension>
        </s:complexContent>
      </s:complexType>
      <s:simpleType name="TipoJustificativa">
        <s:restriction base="s:string">
          <s:enumeration value="alteracaoPrazoCliente" />
          <s:enumeration value="paradaProducao" />
        </s:restriction>
      </s:simpleType>
      <s:element name="carregarOrdensDeServico">
        <s:complexType>
          <s:sequence>
            <s:element minOccurs="0" maxOccurs="1" name="token" type="tns:AccessToken" />
          </s:sequence>
        </s:complexType>
      </s:element>
      <s:element name="carregarOrdensDeServicoResponse">
        <s:complexType>
          <s:sequence>
            <s:element minOccurs="0" maxOccurs="1" name="carregarOrdensDeServicoResult" type="tns:ArrayOfOrdemDeServicoVO" />
          </s:sequence>
        </s:complexType>
      </s:element>
      <s:complexType name="ArrayOfOrdemDeServicoVO">
        <s:sequence>
          <s:element minOccurs="0" maxOccurs="unbounded" name="OrdemDeServicoVO" nillable="true" type="tns:OrdemDeServicoVO" />
        </s:sequence>
      </s:complexType>
    </s:schema>
  </wsdl:types>
  <wsdl:message name="salvarVendedorSoapIn">
    <wsdl:part name="parameters" element="tns:salvarVendedor" />
  </wsdl:message>
  <wsdl:message name="salvarVendedorSoapOut">
    <wsdl:part name="parameters" element="tns:salvarVendedorResponse" />
  </wsdl:message>
  <wsdl:message name="salvarCondicaoDePagamentoSoapIn">
    <wsdl:part name="parameters" element="tns:salvarCondicaoDePagamento" />
  </wsdl:message>
  <wsdl:message name="salvarCondicaoDePagamentoSoapOut">
    <wsdl:part name="parameters" element="tns:salvarCondicaoDePagamentoResponse" />
  </wsdl:message>
  <wsdl:message name="salvarCentroDeCustoSoapIn">
    <wsdl:part name="parameters" element="tns:salvarCentroDeCusto" />
  </wsdl:message>
  <wsdl:message name="salvarCentroDeCustoSoapOut">
    <wsdl:part name="parameters" element="tns:salvarCentroDeCustoResponse" />
  </wsdl:message>
  <wsdl:message name="salvarMateriaPrimaSoapIn">
    <wsdl:part name="parameters" element="tns:salvarMateriaPrima" />
  </wsdl:message>
  <wsdl:message name="salvarMateriaPrimaSoapOut">
    <wsdl:part name="parameters" element="tns:salvarMateriaPrimaResponse" />
  </wsdl:message>
  <wsdl:message name="salvarUnidadeSoapIn">
    <wsdl:part name="parameters" element="tns:salvarUnidade" />
  </wsdl:message>
  <wsdl:message name="salvarUnidadeSoapOut">
    <wsdl:part name="parameters" element="tns:salvarUnidadeResponse" />
  </wsdl:message>
  <wsdl:message name="salvarPapelSoapIn">
    <wsdl:part name="parameters" element="tns:salvarPapel" />
  </wsdl:message>
  <wsdl:message name="salvarPapelSoapOut">
    <wsdl:part name="parameters" element="tns:salvarPapelResponse" />
  </wsdl:message>
  <wsdl:message name="salvarProdutoAcabadoSoapIn">
    <wsdl:part name="parameters" element="tns:salvarProdutoAcabado" />
  </wsdl:message>
  <wsdl:message name="salvarProdutoAcabadoSoapOut">
    <wsdl:part name="parameters" element="tns:salvarProdutoAcabadoResponse" />
  </wsdl:message>
  <wsdl:message name="salvarEstoqueSoapIn">
    <wsdl:part name="parameters" element="tns:salvarEstoque" />
  </wsdl:message>
  <wsdl:message name="salvarEstoqueSoapOut">
    <wsdl:part name="parameters" element="tns:salvarEstoqueResponse" />
  </wsdl:message>
  <wsdl:message name="salvarOperadorSoapIn">
    <wsdl:part name="parameters" element="tns:salvarOperador" />
  </wsdl:message>
  <wsdl:message name="salvarOperadorSoapOut">
    <wsdl:part name="parameters" element="tns:salvarOperadorResponse" />
  </wsdl:message>
  <wsdl:message name="salvarFeriadoSoapIn">
    <wsdl:part name="parameters" element="tns:salvarFeriado" />
  </wsdl:message>
  <wsdl:message name="salvarFeriadoSoapOut">
    <wsdl:part name="parameters" element="tns:salvarFeriadoResponse" />
  </wsdl:message>
  <wsdl:message name="salvarTransportadoraSoapIn">
    <wsdl:part name="parameters" element="tns:salvarTransportadora" />
  </wsdl:message>
  <wsdl:message name="salvarTransportadoraSoapOut">
    <wsdl:part name="parameters" element="tns:salvarTransportadoraResponse" />
  </wsdl:message>
  <wsdl:message name="salvarNaturezaDeOperacaoSoapIn">
    <wsdl:part name="parameters" element="tns:salvarNaturezaDeOperacao" />
  </wsdl:message>
  <wsdl:message name="salvarNaturezaDeOperacaoSoapOut">
    <wsdl:part name="parameters" element="tns:salvarNaturezaDeOperacaoResponse" />
  </wsdl:message>
  <wsdl:message name="salvarVendaSoapIn">
    <wsdl:part name="parameters" element="tns:salvarVenda" />
  </wsdl:message>
  <wsdl:message name="salvarVendaSoapOut">
    <wsdl:part name="parameters" element="tns:salvarVendaResponse" />
  </wsdl:message>
  <wsdl:message name="salvarTipoClienteSoapIn">
    <wsdl:part name="parameters" element="tns:salvarTipoCliente" />
  </wsdl:message>
  <wsdl:message name="salvarTipoClienteSoapOut">
    <wsdl:part name="parameters" element="tns:salvarTipoClienteResponse" />
  </wsdl:message>
  <wsdl:message name="salvarNotaFiscalSoapIn">
    <wsdl:part name="parameters" element="tns:salvarNotaFiscal" />
  </wsdl:message>
  <wsdl:message name="salvarNotaFiscalSoapOut">
    <wsdl:part name="parameters" element="tns:salvarNotaFiscalResponse" />
  </wsdl:message>
  <wsdl:message name="confirmarIntegracaoSoapIn">
    <wsdl:part name="parameters" element="tns:confirmarIntegracao" />
  </wsdl:message>
  <wsdl:message name="confirmarIntegracaoSoapOut">
    <wsdl:part name="parameters" element="tns:confirmarIntegracaoResponse" />
  </wsdl:message>
  <wsdl:message name="carregarMaquinasSoapIn">
    <wsdl:part name="parameters" element="tns:carregarMaquinas" />
  </wsdl:message>
  <wsdl:message name="carregarMaquinasSoapOut">
    <wsdl:part name="parameters" element="tns:carregarMaquinasResponse" />
  </wsdl:message>
  <wsdl:message name="carregarAvisosProducaoSoapIn">
    <wsdl:part name="parameters" element="tns:carregarAvisosProducao" />
  </wsdl:message>
  <wsdl:message name="carregarAvisosProducaoSoapOut">
    <wsdl:part name="parameters" element="tns:carregarAvisosProducaoResponse" />
  </wsdl:message>
  <wsdl:message name="carregarVendasSoapIn">
    <wsdl:part name="parameters" element="tns:carregarVendas" />
  </wsdl:message>
  <wsdl:message name="carregarVendasSoapOut">
    <wsdl:part name="parameters" element="tns:carregarVendasResponse" />
  </wsdl:message>
  <wsdl:message name="carregarMateriaisOSSoapIn">
    <wsdl:part name="parameters" element="tns:carregarMateriaisOS" />
  </wsdl:message>
  <wsdl:message name="carregarMateriaisOSSoapOut">
    <wsdl:part name="parameters" element="tns:carregarMateriaisOSResponse" />
  </wsdl:message>
  <wsdl:message name="carregarApontamentosSoapIn">
    <wsdl:part name="parameters" element="tns:carregarApontamentos" />
  </wsdl:message>
  <wsdl:message name="carregarApontamentosSoapOut">
    <wsdl:part name="parameters" element="tns:carregarApontamentosResponse" />
  </wsdl:message>
  <wsdl:message name="carregarOrdensDeServicoSoapIn">
    <wsdl:part name="parameters" element="tns:carregarOrdensDeServico" />
  </wsdl:message>
  <wsdl:message name="carregarOrdensDeServicoSoapOut">
    <wsdl:part name="parameters" element="tns:carregarOrdensDeServicoResponse" />
  </wsdl:message>
  <wsdl:portType name="WSIntegraImespSoap">
    <wsdl:operation name="salvarVendedor">
      <wsdl:input message="tns:salvarVendedorSoapIn" />
      <wsdl:output message="tns:salvarVendedorSoapOut" />
    </wsdl:operation>
    <wsdl:operation name="salvarCondicaoDePagamento">
      <wsdl:input message="tns:salvarCondicaoDePagamentoSoapIn" />
      <wsdl:output message="tns:salvarCondicaoDePagamentoSoapOut" />
    </wsdl:operation>
    <wsdl:operation name="salvarCentroDeCusto">
      <wsdl:input message="tns:salvarCentroDeCustoSoapIn" />
      <wsdl:output message="tns:salvarCentroDeCustoSoapOut" />
    </wsdl:operation>
    <wsdl:operation name="salvarMateriaPrima">
      <wsdl:input message="tns:salvarMateriaPrimaSoapIn" />
      <wsdl:output message="tns:salvarMateriaPrimaSoapOut" />
    </wsdl:operation>
    <wsdl:operation name="salvarUnidade">
      <wsdl:input message="tns:salvarUnidadeSoapIn" />
      <wsdl:output message="tns:salvarUnidadeSoapOut" />
    </wsdl:operation>
    <wsdl:operation name="salvarPapel">
      <wsdl:input message="tns:salvarPapelSoapIn" />
      <wsdl:output message="tns:salvarPapelSoapOut" />
    </wsdl:operation>
    <wsdl:operation name="salvarProdutoAcabado">
      <wsdl:input message="tns:salvarProdutoAcabadoSoapIn" />
      <wsdl:output message="tns:salvarProdutoAcabadoSoapOut" />
    </wsdl:operation>
    <wsdl:operation name="salvarEstoque">
      <wsdl:input message="tns:salvarEstoqueSoapIn" />
      <wsdl:output message="tns:salvarEstoqueSoapOut" />
    </wsdl:operation>
    <wsdl:operation name="salvarOperador">
      <wsdl:input message="tns:salvarOperadorSoapIn" />
      <wsdl:output message="tns:salvarOperadorSoapOut" />
    </wsdl:operation>
    <wsdl:operation name="salvarFeriado">
      <wsdl:input message="tns:salvarFeriadoSoapIn" />
      <wsdl:output message="tns:salvarFeriadoSoapOut" />
    </wsdl:operation>
    <wsdl:operation name="salvarTransportadora">
      <wsdl:input message="tns:salvarTransportadoraSoapIn" />
      <wsdl:output message="tns:salvarTransportadoraSoapOut" />
    </wsdl:operation>
    <wsdl:operation name="salvarNaturezaDeOperacao">
      <wsdl:input message="tns:salvarNaturezaDeOperacaoSoapIn" />
      <wsdl:output message="tns:salvarNaturezaDeOperacaoSoapOut" />
    </wsdl:operation>
    <wsdl:operation name="salvarVenda">
      <wsdl:input message="tns:salvarVendaSoapIn" />
      <wsdl:output message="tns:salvarVendaSoapOut" />
    </wsdl:operation>
    <wsdl:operation name="salvarTipoCliente">
      <wsdl:input message="tns:salvarTipoClienteSoapIn" />
      <wsdl:output message="tns:salvarTipoClienteSoapOut" />
    </wsdl:operation>
    <wsdl:operation name="salvarNotaFiscal">
      <wsdl:input message="tns:salvarNotaFiscalSoapIn" />
      <wsdl:output message="tns:salvarNotaFiscalSoapOut" />
    </wsdl:operation>
    <wsdl:operation name="confirmarIntegracao">
      <wsdl:input message="tns:confirmarIntegracaoSoapIn" />
      <wsdl:output message="tns:confirmarIntegracaoSoapOut" />
    </wsdl:operation>
    <wsdl:operation name="carregarMaquinas">
      <wsdl:input message="tns:carregarMaquinasSoapIn" />
      <wsdl:output message="tns:carregarMaquinasSoapOut" />
    </wsdl:operation>
    <wsdl:operation name="carregarAvisosProducao">
      <wsdl:input message="tns:carregarAvisosProducaoSoapIn" />
      <wsdl:output message="tns:carregarAvisosProducaoSoapOut" />
    </wsdl:operation>
    <wsdl:operation name="carregarVendas">
      <wsdl:input message="tns:carregarVendasSoapIn" />
      <wsdl:output message="tns:carregarVendasSoapOut" />
    </wsdl:operation>
    <wsdl:operation name="carregarMateriaisOS">
      <wsdl:input message="tns:carregarMateriaisOSSoapIn" />
      <wsdl:output message="tns:carregarMateriaisOSSoapOut" />
    </wsdl:operation>
    <wsdl:operation name="carregarApontamentos">
      <wsdl:input message="tns:carregarApontamentosSoapIn" />
      <wsdl:output message="tns:carregarApontamentosSoapOut" />
    </wsdl:operation>
    <wsdl:operation name="carregarOrdensDeServico">
      <wsdl:input message="tns:carregarOrdensDeServicoSoapIn" />
      <wsdl:output message="tns:carregarOrdensDeServicoSoapOut" />
    </wsdl:operation>
  </wsdl:portType>
  <wsdl:binding name="WSIntegraImespSoap" type="tns:WSIntegraImespSoap">
    <soap:binding transport="http://schemas.xmlsoap.org/soap/http" />
    <wsdl:operation name="salvarVendedor">
      <soap:operation soapAction="http://tempuri.org/salvarVendedor" style="document" />
      <wsdl:input>
        <soap:body use="literal" />
      </wsdl:input>
      <wsdl:output>
        <soap:body use="literal" />
      </wsdl:output>
    </wsdl:operation>
    <wsdl:operation name="salvarCondicaoDePagamento">
      <soap:operation soapAction="http://tempuri.org/salvarCondicaoDePagamento" style="document" />
      <wsdl:input>
        <soap:body use="literal" />
      </wsdl:input>
      <wsdl:output>
        <soap:body use="literal" />
      </wsdl:output>
    </wsdl:operation>
    <wsdl:operation name="salvarCentroDeCusto">
      <soap:operation soapAction="http://tempuri.org/salvarCentroDeCusto" style="document" />
      <wsdl:input>
        <soap:body use="literal" />
      </wsdl:input>
      <wsdl:output>
        <soap:body use="literal" />
      </wsdl:output>
    </wsdl:operation>
    <wsdl:operation name="salvarMateriaPrima">
      <soap:operation soapAction="http://tempuri.org/salvarMateriaPrima" style="document" />
      <wsdl:input>
        <soap:body use="literal" />
      </wsdl:input>
      <wsdl:output>
        <soap:body use="literal" />
      </wsdl:output>
    </wsdl:operation>
    <wsdl:operation name="salvarUnidade">
      <soap:operation soapAction="http://tempuri.org/salvarUnidade" style="document" />
      <wsdl:input>
        <soap:body use="literal" />
      </wsdl:input>
      <wsdl:output>
        <soap:body use="literal" />
      </wsdl:output>
    </wsdl:operation>
    <wsdl:operation name="salvarPapel">
      <soap:operation soapAction="http://tempuri.org/salvarPapel" style="document" />
      <wsdl:input>
        <soap:body use="literal" />
      </wsdl:input>
      <wsdl:output>
        <soap:body use="literal" />
      </wsdl:output>
    </wsdl:operation>
    <wsdl:operation name="salvarProdutoAcabado">
      <soap:operation soapAction="http://tempuri.org/salvarProdutoAcabado" style="document" />
      <wsdl:input>
        <soap:body use="literal" />
      </wsdl:input>
      <wsdl:output>
        <soap:body use="literal" />
      </wsdl:output>
    </wsdl:operation>
    <wsdl:operation name="salvarEstoque">
      <soap:operation soapAction="http://tempuri.org/salvarEstoque" style="document" />
      <wsdl:input>
        <soap:body use="literal" />
      </wsdl:input>
      <wsdl:output>
        <soap:body use="literal" />
      </wsdl:output>
    </wsdl:operation>
    <wsdl:operation name="salvarOperador">
      <soap:operation soapAction="http://tempuri.org/salvarOperador" style="document" />
      <wsdl:input>
        <soap:body use="literal" />
      </wsdl:input>
      <wsdl:output>
        <soap:body use="literal" />
      </wsdl:output>
    </wsdl:operation>
    <wsdl:operation name="salvarFeriado">
      <soap:operation soapAction="http://tempuri.org/salvarFeriado" style="document" />
      <wsdl:input>
        <soap:body use="literal" />
      </wsdl:input>
      <wsdl:output>
        <soap:body use="literal" />
      </wsdl:output>
    </wsdl:operation>
    <wsdl:operation name="salvarTransportadora">
      <soap:operation soapAction="http://tempuri.org/salvarTransportadora" style="document" />
      <wsdl:input>
        <soap:body use="literal" />
      </wsdl:input>
      <wsdl:output>
        <soap:body use="literal" />
      </wsdl:output>
    </wsdl:operation>
    <wsdl:operation name="salvarNaturezaDeOperacao">
      <soap:operation soapAction="http://tempuri.org/salvarNaturezaDeOperacao" style="document" />
      <wsdl:input>
        <soap:body use="literal" />
      </wsdl:input>
      <wsdl:output>
        <soap:body use="literal" />
      </wsdl:output>
    </wsdl:operation>
    <wsdl:operation name="salvarVenda">
      <soap:operation soapAction="http://tempuri.org/salvarVenda" style="document" />
      <wsdl:input>
        <soap:body use="literal" />
      </wsdl:input>
      <wsdl:output>
        <soap:body use="literal" />
      </wsdl:output>
    </wsdl:operation>
    <wsdl:operation name="salvarTipoCliente">
      <soap:operation soapAction="http://tempuri.org/salvarTipoCliente" style="document" />
      <wsdl:input>
        <soap:body use="literal" />
      </wsdl:input>
      <wsdl:output>
        <soap:body use="literal" />
      </wsdl:output>
    </wsdl:operation>
    <wsdl:operation name="salvarNotaFiscal">
      <soap:operation soapAction="http://tempuri.org/salvarNotaFiscal" style="document" />
      <wsdl:input>
        <soap:body use="literal" />
      </wsdl:input>
      <wsdl:output>
        <soap:body use="literal" />
      </wsdl:output>
    </wsdl:operation>
    <wsdl:operation name="confirmarIntegracao">
      <soap:operation soapAction="http://tempuri.org/confirmarIntegracao" style="document" />
      <wsdl:input>
        <soap:body use="literal" />
      </wsdl:input>
      <wsdl:output>
        <soap:body use="literal" />
      </wsdl:output>
    </wsdl:operation>
    <wsdl:operation name="carregarMaquinas">
      <soap:operation soapAction="http://tempuri.org/carregarMaquinas" style="document" />
      <wsdl:input>
        <soap:body use="literal" />
      </wsdl:input>
      <wsdl:output>
        <soap:body use="literal" />
      </wsdl:output>
    </wsdl:operation>
    <wsdl:operation name="carregarAvisosProducao">
      <soap:operation soapAction="http://tempuri.org/carregarAvisosProducao" style="document" />
      <wsdl:input>
        <soap:body use="literal" />
      </wsdl:input>
      <wsdl:output>
        <soap:body use="literal" />
      </wsdl:output>
    </wsdl:operation>
    <wsdl:operation name="carregarVendas">
      <soap:operation soapAction="http://tempuri.org/carregarVendas" style="document" />
      <wsdl:input>
        <soap:body use="literal" />
      </wsdl:input>
      <wsdl:output>
        <soap:body use="literal" />
      </wsdl:output>
    </wsdl:operation>
    <wsdl:operation name="carregarMateriaisOS">
      <soap:operation soapAction="http://tempuri.org/carregarMateriaisOS" style="document" />
      <wsdl:input>
        <soap:body use="literal" />
      </wsdl:input>
      <wsdl:output>
        <soap:body use="literal" />
      </wsdl:output>
    </wsdl:operation>
    <wsdl:operation name="carregarApontamentos">
      <soap:operation soapAction="http://tempuri.org/carregarApontamentos" style="document" />
      <wsdl:input>
        <soap:body use="literal" />
      </wsdl:input>
      <wsdl:output>
        <soap:body use="literal" />
      </wsdl:output>
    </wsdl:operation>
    <wsdl:operation name="carregarOrdensDeServico">
      <soap:operation soapAction="http://tempuri.org/carregarOrdensDeServico" style="document" />
      <wsdl:input>
        <soap:body use="literal" />
      </wsdl:input>
      <wsdl:output>
        <soap:body use="literal" />
      </wsdl:output>
    </wsdl:operation>
  </wsdl:binding>
  <wsdl:binding name="WSIntegraImespSoap12" type="tns:WSIntegraImespSoap">
    <soap12:binding transport="http://schemas.xmlsoap.org/soap/http" />
    <wsdl:operation name="salvarVendedor">
      <soap12:operation soapAction="http://tempuri.org/salvarVendedor" style="document" />
      <wsdl:input>
        <soap12:body use="literal" />
      </wsdl:input>
      <wsdl:output>
        <soap12:body use="literal" />
      </wsdl:output>
    </wsdl:operation>
    <wsdl:operation name="salvarCondicaoDePagamento">
      <soap12:operation soapAction="http://tempuri.org/salvarCondicaoDePagamento" style="document" />
      <wsdl:input>
        <soap12:body use="literal" />
      </wsdl:input>
      <wsdl:output>
        <soap12:body use="literal" />
      </wsdl:output>
    </wsdl:operation>
    <wsdl:operation name="salvarCentroDeCusto">
      <soap12:operation soapAction="http://tempuri.org/salvarCentroDeCusto" style="document" />
      <wsdl:input>
        <soap12:body use="literal" />
      </wsdl:input>
      <wsdl:output>
        <soap12:body use="literal" />
      </wsdl:output>
    </wsdl:operation>
    <wsdl:operation name="salvarMateriaPrima">
      <soap12:operation soapAction="http://tempuri.org/salvarMateriaPrima" style="document" />
      <wsdl:input>
        <soap12:body use="literal" />
      </wsdl:input>
      <wsdl:output>
        <soap12:body use="literal" />
      </wsdl:output>
    </wsdl:operation>
    <wsdl:operation name="salvarUnidade">
      <soap12:operation soapAction="http://tempuri.org/salvarUnidade" style="document" />
      <wsdl:input>
        <soap12:body use="literal" />
      </wsdl:input>
      <wsdl:output>
        <soap12:body use="literal" />
      </wsdl:output>
    </wsdl:operation>
    <wsdl:operation name="salvarPapel">
      <soap12:operation soapAction="http://tempuri.org/salvarPapel" style="document" />
      <wsdl:input>
        <soap12:body use="literal" />
      </wsdl:input>
      <wsdl:output>
        <soap12:body use="literal" />
      </wsdl:output>
    </wsdl:operation>
    <wsdl:operation name="salvarProdutoAcabado">
      <soap12:operation soapAction="http://tempuri.org/salvarProdutoAcabado" style="document" />
      <wsdl:input>
        <soap12:body use="literal" />
      </wsdl:input>
      <wsdl:output>
        <soap12:body use="literal" />
      </wsdl:output>
    </wsdl:operation>
    <wsdl:operation name="salvarEstoque">
      <soap12:operation soapAction="http://tempuri.org/salvarEstoque" style="document" />
      <wsdl:input>
        <soap12:body use="literal" />
      </wsdl:input>
      <wsdl:output>
        <soap12:body use="literal" />
      </wsdl:output>
    </wsdl:operation>
    <wsdl:operation name="salvarOperador">
      <soap12:operation soapAction="http://tempuri.org/salvarOperador" style="document" />
      <wsdl:input>
        <soap12:body use="literal" />
      </wsdl:input>
      <wsdl:output>
        <soap12:body use="literal" />
      </wsdl:output>
    </wsdl:operation>
    <wsdl:operation name="salvarFeriado">
      <soap12:operation soapAction="http://tempuri.org/salvarFeriado" style="document" />
      <wsdl:input>
        <soap12:body use="literal" />
      </wsdl:input>
      <wsdl:output>
        <soap12:body use="literal" />
      </wsdl:output>
    </wsdl:operation>
    <wsdl:operation name="salvarTransportadora">
      <soap12:operation soapAction="http://tempuri.org/salvarTransportadora" style="document" />
      <wsdl:input>
        <soap12:body use="literal" />
      </wsdl:input>
      <wsdl:output>
        <soap12:body use="literal" />
      </wsdl:output>
    </wsdl:operation>
    <wsdl:operation name="salvarNaturezaDeOperacao">
      <soap12:operation soapAction="http://tempuri.org/salvarNaturezaDeOperacao" style="document" />
      <wsdl:input>
        <soap12:body use="literal" />
      </wsdl:input>
      <wsdl:output>
        <soap12:body use="literal" />
      </wsdl:output>
    </wsdl:operation>
    <wsdl:operation name="salvarVenda">
      <soap12:operation soapAction="http://tempuri.org/salvarVenda" style="document" />
      <wsdl:input>
        <soap12:body use="literal" />
      </wsdl:input>
      <wsdl:output>
        <soap12:body use="literal" />
      </wsdl:output>
    </wsdl:operation>
    <wsdl:operation name="salvarTipoCliente">
      <soap12:operation soapAction="http://tempuri.org/salvarTipoCliente" style="document" />
      <wsdl:input>
        <soap12:body use="literal" />
      </wsdl:input>
      <wsdl:output>
        <soap12:body use="literal" />
      </wsdl:output>
    </wsdl:operation>
    <wsdl:operation name="salvarNotaFiscal">
      <soap12:operation soapAction="http://tempuri.org/salvarNotaFiscal" style="document" />
      <wsdl:input>
        <soap12:body use="literal" />
      </wsdl:input>
      <wsdl:output>
        <soap12:body use="literal" />
      </wsdl:output>
    </wsdl:operation>
    <wsdl:operation name="confirmarIntegracao">
      <soap12:operation soapAction="http://tempuri.org/confirmarIntegracao" style="document" />
      <wsdl:input>
        <soap12:body use="literal" />
      </wsdl:input>
      <wsdl:output>
        <soap12:body use="literal" />
      </wsdl:output>
    </wsdl:operation>
    <wsdl:operation name="carregarMaquinas">
      <soap12:operation soapAction="http://tempuri.org/carregarMaquinas" style="document" />
      <wsdl:input>
        <soap12:body use="literal" />
      </wsdl:input>
      <wsdl:output>
        <soap12:body use="literal" />
      </wsdl:output>
    </wsdl:operation>
    <wsdl:operation name="carregarAvisosProducao">
      <soap12:operation soapAction="http://tempuri.org/carregarAvisosProducao" style="document" />
      <wsdl:input>
        <soap12:body use="literal" />
      </wsdl:input>
      <wsdl:output>
        <soap12:body use="literal" />
      </wsdl:output>
    </wsdl:operation>
    <wsdl:operation name="carregarVendas">
      <soap12:operation soapAction="http://tempuri.org/carregarVendas" style="document" />
      <wsdl:input>
        <soap12:body use="literal" />
      </wsdl:input>
      <wsdl:output>
        <soap12:body use="literal" />
      </wsdl:output>
    </wsdl:operation>
    <wsdl:operation name="carregarMateriaisOS">
      <soap12:operation soapAction="http://tempuri.org/carregarMateriaisOS" style="document" />
      <wsdl:input>
        <soap12:body use="literal" />
      </wsdl:input>
      <wsdl:output>
        <soap12:body use="literal" />
      </wsdl:output>
    </wsdl:operation>
    <wsdl:operation name="carregarApontamentos">
      <soap12:operation soapAction="http://tempuri.org/carregarApontamentos" style="document" />
      <wsdl:input>
        <soap12:body use="literal" />
      </wsdl:input>
      <wsdl:output>
        <soap12:body use="literal" />
      </wsdl:output>
    </wsdl:operation>
    <wsdl:operation name="carregarOrdensDeServico">
      <soap12:operation soapAction="http://tempuri.org/carregarOrdensDeServico" style="document" />
      <wsdl:input>
        <soap12:body use="literal" />
      </wsdl:input>
      <wsdl:output>
        <soap12:body use="literal" />
      </wsdl:output>
    </wsdl:operation>
  </wsdl:binding>
  <wsdl:service name="WSIntegraImesp">
    <wsdl:port name="WSIntegraImespSoap" binding="tns:WSIntegraImespSoap">
      <soap:address location="http://localhost:8081/WSIntegraIMESP/WSIntegraImesp.asmx" />
    </wsdl:port>
    <wsdl:port name="WSIntegraImespSoap12" binding="tns:WSIntegraImespSoap12">
      <soap12:address location="http://localhost:8081/WSIntegraIMESP/WSIntegraImesp.asmx" />
    </wsdl:port>
  </wsdl:service>
</wsdl:definitions>