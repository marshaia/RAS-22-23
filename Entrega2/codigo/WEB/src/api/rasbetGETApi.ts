import {genericGET, RasbetApiResponse} from "./rasbetApiResponse"

export const getAllAvailableGames = async () : Promise<RasbetApiResponse> => {
    return genericGET('http://localhost:8080/jogos')
}

export const getAllSports = async () : Promise<RasbetApiResponse> => {
    return genericGET('http://localhost:8080/desportos')
}

export const getAllCompetitions = async () : Promise<RasbetApiResponse> => {
    return genericGET('http://localhost:8080/competicoes')
}

export const getTransactions = async (token: string) : Promise<RasbetApiResponse> => {
    return genericGET('http://localhost:8080/historico/transacoes', token)
}

export const getApostas = async (token: string) : Promise<RasbetApiResponse> => {
    return genericGET('http://localhost:8080/historico/apostas', token)
}

export const getUserNotificacoes = async (token: string) : Promise<RasbetApiResponse> => {
    return genericGET('http://localhost:8080/notificacoes', token)
}

export const getNumUsersOnline = async (token: string) : Promise<RasbetApiResponse> => {
    return genericGET('http://localhost:8080/admin/usersOnline', token)
}

export const getEspecialistaResultados = async (token: string) : Promise<RasbetApiResponse> => {
    return genericGET('http://localhost:8080/especialista/resultados', token)
}

export const getEspecialistaGames = async (token: string) : Promise<RasbetApiResponse> => {
    return genericGET('http://localhost:8080/especialista/jogos', token)
}