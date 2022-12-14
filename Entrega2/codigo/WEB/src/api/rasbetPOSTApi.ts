import {genericPOST, RasbetApiResponse} from "./rasbetApiResponse"
import {ApostaItem} from "../models/aposta"

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
                                       cc: string, endereco: string, telefone: number, tipo: string) : Promise<RasbetApiResponse> => {
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
        carteira: carteira,
    })
}

export const eliminaNotificacao = async (token: string, notifID: number) : Promise<RasbetApiResponse> => {
    return genericPOST('http://localhost:8080/notificacoes', {
        token: token,
        idnotificacao: notifID,
    })
}