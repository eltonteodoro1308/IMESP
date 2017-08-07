#INCLUDE 'TOTVS.CH'

/*/{Protheus.doc} IOSA1BLD
//Retorno uma instância de objeto da classe IOSA1CLS
@author Elton Teodoro Alves
@since 07/08/2017
@version 12.1.017
@return return, Instância de objeto da classe IOSA1CLS
/*/
User Function IOSA1BLD()

	Local oObject := IOSA1CLS():New()

Return oObject

/*/{Protheus.doc} IOSA1CLS
//Classe que representa o cadastro do cliente e seus contatos a serem incluidos/atualizados na base
@author Elton Teodoro Alves
@since 04/08/2017
@version 12.1.017
/*/
Class IOSA1CLS

	// idSistemaCriacaoOrAlteracao,

	Data cXCDCDCF // cliente.IdCliente
	Data cCOD     // cliente.CodigoERP
	Data cNREDUZ  // sNomeFantasia,
	Data cNOME    // cliente.NomeCliente
	Data cCGC     // cliente.DocumentoCliente
	Data cINSCR   // pj.InscricaoEstadual
	Data cINSCRM  // pj.InscricaoMunicipal
	Data cMSBLQL  // cliente.ClienteAtivo ? (short?)1 : (short?)0,
	Data cPESSOA  // cliente.IdTipoEsfera == 4 ? "F" : "J",//Se for pessoa física é F, senão for é J.

	// "S",//Fixo Sim,
	// "S",//Fixo Sim,

	Data cXESFERA // sEsfera
	Data dDTCAD	  // sSistemaCriacao
	Data dXDTALT  // sSistemaAlteracao
	Data dDTNASC  // cliente.PessoaFisica != null ? cliente.PessoaFisica.DataNascimento : null,//Se PessoaFisica diferemte de nulo, manda a data de nascimento.
	Data cXSEXO   // cliente.PessoaFisica == null ? "N" : (cliente.PessoaFisica.IdTipoSexo == 1 ? "F" : "M")
	Data cXORGPUB // cliente.OrgaoPublico != null ? (short?)1 : (short?)0,
	Data cEND     // endPrincipal.TipoLogradouro // endPrincipal.Logradouro	// endPrincipal.LogradouroNumero
	Data cCOMPLEM // endPrincipal.LogradouroComplemento
	Data cBAIRRO  // endPrincipal.Bairro
	Data cCOD_MUN // endPrincipal.CodigoMunicipio
	Data cMUN     // endPrincipal.Municipio,
	Data cEST     // endPrincipal.SiglaUnidadeFederativa,
	Data cCEP     // endPrincipal.CEP,
	Data cXNMPAIS // dPaisPrincipal.NomePais,
	Data cENDCOB  // endCobranca.TipoLogradouro	// endCobranca.Logradouro // endCobranca.LogradouroNumero
	Data cXCMPCOB // endCobranca.LogradouroComplemento,
	Data cXBROCOB // endCobranca.Bairro,
	Data cXCDMNCB // endCobranca.CodigoMunicipio,
	Data cXMUNCOB // endCobranca.Municipio,
	Data cXESTCOB // endCobranca.SiglaUnidadeFederativa,
	Data cXCEPCOB // endCobranca.CEP,
	Data cXNMPSCB // dPaisCobranca.NomePais,
	Data cENDENT  // endEntregaPrincipal.TipoLogradouro // endEntregaPrincipal.Logradouro // endEntregaPrincipal.LogradouroNumero
	Data cXCMPENT // endEntregaPrincipal.LogradouroComplemento
	Data cXBROENT // endEntregaPrincipal.Bairro
	Data cXCDMNET // endEntregaPrincipal.CodigoMunicipio
	Data cXMUNENT // endEntregaPrincipal.Municipio,
	Data cXESTENT // endEntregaPrincipal.SiglaUnidadeFederativa,
	Data cXCEPENT // endEntregaPrincipal.CEP,
	Data cXNMPSET // dPaisEntregaPrincipal.NomePais,
	Data cDDI     // meioComunicacao.DDI,
	Data cDDD     // meioComunicacao.DDD,
	Data cTEL     // meioComunicacao.Telefone,
	Data cXRAMAL  // meioComunicacao.Ramal,

	// meioComunicacaoDonoConta.Email,
	// clienteContatoDonodaConta.NomeContato,
	// meioComunicacaoFax.DDD + meioComunicacaoFax.Telefone

	Data cEMAIL
	Data cXDHCDCF
	Data lErroAuto
	Data cErroMsg
	Data aContatos

	Method New() Constructor

End Class

/*/{Protheus.doc} New
//Método Contrutor da Classe Cliente
@author Elton Teodoro Alves
@since 04/08/2017
@version 12.1.017
/*/
Method New() Class IOSA1CLS
Return Self