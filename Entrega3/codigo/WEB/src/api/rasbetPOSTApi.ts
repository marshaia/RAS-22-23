import {genericPOST, RasbetApiResponse} from "./rasbetApiResponse"
import {ApostaItem} from "../models/aposta"
import { gameToSend, rasbetResultado } from '../models/rasbetJogo'

export const loginPOST = async (email:String,password:String) : Promise<RasbetApiResponse> => {
    return genericPOST('http://localhost:8080/login',{
        type: "email",
        email: email,
        password: password,
    });
}

export const logoutPOST = async (token:String) : Promise<RasbetApiResponse> => {
    return genericPOST('http://localhost:8080/logout',{
        token: token,
    });
}

export const getUserPOST = async (token:string) : Promise<RasbetApiResponse> => {

    return genericPOST('http://localhost:8080/login',{
        type: "token",
        token: token,
    });
}

export const editProfilePOST = async (token: string, email: string, nome: string, endereco: string, telefone: number) : Promise<RasbetApiResponse> => {

    return genericPOST('http://localhost:8080/editInfo', {
        token: token,
        email: email,
        nome: nome,
        endereco: endereco,
        telefone: telefone,
    })
}

export const editPasswordPOST = async (token: string, oldPassword: string, newPassword: string) : Promise<RasbetApiResponse> => {

    return genericPOST('http://localhost:8080/editPassword', {
        token: token,
        oldPassword: oldPassword,
        newPassword: newPassword,
    })
}

export const registerUserPOST = async (email: string,password:string, nome: string, datanascimento: string, nif: string,
                                       cc: string, endereco: string, telefone: number, tipo: string, sportsID?: number[]) : Promise<RasbetApiResponse> => {
    return genericPOST('http://localhost:8080/register', {
        email: email,
        password: password,
        nome: nome,
        datanascimento: datanascimento,
        nif: nif,
        cc: cc,
        endereco: endereco,
        telefone: telefone,
        tipo: tipo,
        sports: sportsID ?? null,
    })
}

export const transacaoCarteiraPOST = async (token: string,valor: number, descricao: string) : Promise<RasbetApiResponse> => {
    return genericPOST('http://localhost:8080/movimento', {
        token: token,
        valor: valor,
        descricao: descricao,
    })
}

export const boletimPOST = async (token: string, items: ApostaItem[], simples: boolean, valor: number, carteira :boolean) : Promise<RasbetApiResponse> => {
    return genericPOST('http://localhost:8080/criarAposta', {
        token: token,
        items: JSON.stringify(items),
        simples: simples ? 1 : 0,
        valorTotal: valor,
        carteira: carteira ? 1 : 0,
    })
}

export const eliminaNotificacao = async (token: string, notifID: number) : Promise<RasbetApiResponse> => {
    return genericPOST('http://localhost:8080/notificacoes', {
        token: token,
        idnotificacao: notifID,
    })
}

export const enviaOddsPOST = async (token: string, idjogo: number, resultados: rasbetResultado[] ) : Promise<RasbetApiResponse> => {
    return genericPOST('http://localhost:8080/especialista/odds', {
        token: token,
        idjogo: idjogo,
        resultados: JSON.stringify(resultados),
    })
}

export const terminaJogoPOST = async (token: string, idJogo: number, winner: string, score: string) : Promise<RasbetApiResponse> => {
    return genericPOST('http://localhost:8080/admin/jogos', {
        token: token,
        game: idJogo,
        winner: winner,
        score: score,
    })
}

export const criaJogoPOST = async (token: string, game: gameToSend) : Promise<RasbetApiResponse> => {
    return genericPOST('http://localhost:8080/admin/criaJogo', {
        token: token,
        completed: 0,
        iddesporto: game.iddesporto,
        idcompeticao: game.idcompeticao,
        resultados: JSON.stringify(game.resultados),
        starttime: game.starttime,
        hometeam: game.homeTeam,
        awayteam: game.awayTeam,
    })
}

export const alteraEstadoApostaPOST = async (token: string, idAposta: number, estado: string) : Promise<RasbetApiResponse> => {
    return genericPOST('http://localhost:8080/admin/apostas', {
        token: token,
        idaposta: idAposta,
        estado: estado,
    })
}

export const alteraEstadoPromoPOST = async (token: string, idpromo: number) : Promise<RasbetApiResponse> => {
    return genericPOST('http://localhost:8080/admin/alteraPromo', {
        token: token,
        idPromo: idpromo,
    })
}

export const criaPromocaoPOST = async (token: string, msg: string) : Promise<RasbetApiResponse> => {
    return genericPOST('http://localhost:8080/admin/promos', {
        token: token,
        descricao: msg,
    })
}

export const seguirJogoPOST = async (token: string, idjogo: number, add: boolean) : Promise<RasbetApiResponse> => {
    return genericPOST('http://localhost:8080/seguir', {
        token: token,
        idJogo: idjogo,
        add: add ? 1 : 0,
    })
}