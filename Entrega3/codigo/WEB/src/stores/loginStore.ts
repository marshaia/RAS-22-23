import { defineStore } from "pinia";
import { User, adminUser } from "../models/user";
import { ApostaSistema } from '../models/aposta'
import { Notificacao } from '../models/notificacoes'
import { Promocao, apostadorPromocao } from '../models/promocoes'
import { HistoricoAposta, HistoricoTrasacao } from "../models/historicos";
import { getTransactions, getApostas, getEspecialistaResultados, getUserNotificacoes, getAdminApostas, getAdminUsers, getAdminPromocoes, getUserPromocoes } from "../api/rasbetGETApi";
import { editProfilePOST, getUserPOST, loginPOST, logoutPOST, registerUserPOST, eliminaNotificacao, alteraEstadoApostaPOST, alteraEstadoPromoPOST, criaPromocaoPOST, seguirJogoPOST} from "../api/rasbetPOSTApi";
import { RasbetApiResponse } from "../api/rasbetApiResponse";

interface loginStore {
  loggedIn: boolean;
  fetching: boolean
  error: string | null;
  user: User | null;
  transacoes: [HistoricoTrasacao] | null;
  apostas: [HistoricoAposta] | null;
  especialistaResultados: [] | null;
  notificacoes: [Notificacao] | null;
  promocoes: apostadorPromocao[] | null;
  token: string;
  userJogos: number[] | null;
  adminApostas: ApostaSistema[] | null;
  adminsApostasToShow: ApostaSistema[] | null;
  adminUsers: adminUser[] | null;
  adminPromos: Promocao[] | null;
}

export const loginState = defineStore("login", {
  state: (): loginStore => {
    return {
      loggedIn: false,
      fetching: false,
      user: null,
      error: null,
      transacoes: null,
      apostas: null,
      especialistaResultados: null,
      notificacoes: null,
      promocoes: null,
      token: "",
      userJogos: null,
      adminApostas: null,
      adminsApostasToShow: null,
      adminUsers: null,
      adminPromos: null,
    };
  },
  actions: {

    checkLogin() {
      let tokenStr = localStorage.getItem("rasbetLoginToken") ?? "";
      if (tokenStr !== "") {
        this.token = JSON.parse(tokenStr);
        if(this.user === null){
          this.getUserByToken()
        }
      }
      else{
        this.logOut()
      }

    },

    getUserByToken(){
      this.fetching = true;
      getUserPOST(this.token).then(res => {
        this.setUserAndToken(res)
      })
      this.fetching = false;
    },

    async login(email: string, pass: string) : Promise<boolean> {
      this.fetching = true
      const res = await loginPOST(email,pass);
      this.fetching = false;

      return this.setUserAndToken(res);
    },

    setUserAndToken(res : RasbetApiResponse){
      if (res.code === 200) {
        this.user = res.data
        this.token = this.user?.token ?? "";
        localStorage.setItem("rasbetLoginToken", JSON.stringify(this.token));
        this.userJogos = this.user?.jogos ?? null;
        this.loggedIn = true;
        this.error = null;
      }
      else {
        this.logOut();
        this.error = "Login Inválido";
      }
      return this.loggedIn
    },

    logOut() {
      logoutPOST(this.token);
      this.user = null;
      this.loggedIn = false;
      this.error = null;
      this.token = "";
      localStorage.removeItem("rasbetLoginToken");
      this.adminApostas = null;
      this.adminsApostasToShow = null;
      this.adminUsers = null;
      this.transacoes = null;
      this.apostas = null;
      this.especialistaResultados = null;
      this.notificacoes = null;
      this.promocoes = null;
      this.adminPromos = null;
      this.userJogos = null;
    },

    getUtilizadorEncargo(){
      if(this.loggedIn) return this.user?.encargo;
      return null;
    },

    async editProfile (email: string, nome: string, endereco: string, telefone: number) {
      this.fetching = true
      const res = await editProfilePOST(this.token, email, nome, endereco, telefone)
      this.fetching = false

      return this.setEditedUser(res);
    },

    setEditedUser(res : RasbetApiResponse) {
      if (res.code === 200) {
        this.user = res.data
      }
      else {
        this.error = "Ups! Something went wrong..."
      }
      return this.loggedIn;
    },

    getUserTransactions() {
      this.fetching = true;
      getTransactions(this.token).then((res) => {
        if (res.code === 200) { 
          this.transacoes = res.data 
        }
        else { 
          this.transacoes = null;
          this.error = "Ups! Something went wrong..."
        }
      });
      this.fetching = false;
    },

    getUserApostas() {
      this.fetching = true;
      getApostas(this.token).then((res) => {
        if (res.code === 200) { 
          this.apostas = res.data 
        }
        else { 
          this.apostas = null;
          this.error = "Ups! Something went wrong..."
        }
      });
      this.fetching = false;
    },


    async register(email: string, pass: string, nome: string, datanascimento: string, nif: string, 
                   cc: string, endereco: string, telefone: number, tipo: string, sportsID?: number[]) : Promise<boolean> {
      this.fetching = true
      const res = await registerUserPOST(email,pass,nome,datanascimento,nif,cc,endereco,telefone,tipo, sportsID);
      this.fetching = false;

      if (tipo === "apostador") {  // registo via utilizador normal  
        return this.setUserAndToken(res);
      }
      else {   // registo feito pelo administrador
        if (res.code === 200) return true;
        else return false;
      }
    },

    getEspecialistaResultados() {
      if (this.checkEspecialista()) {
        this.fetching = true;
        getEspecialistaResultados(this.token).then((res) => {
          if (res.code === 200) { 
            this.especialistaResultados = res.data 
          }
          else { 
            this.especialistaResultados = null;
            this.error = "Ups! Something went wrong..."
          }
        });
        this.fetching = false; 
      }

    },

    getNotificacoes() {
      this.fetching = true;
      getUserNotificacoes(this.token).then((res) => {
        if (res.code === 200) { 
          this.notificacoes = res.data 
        }
        else { 
          this.notificacoes = null;
          this.error = "Ups! Something went wrong..."
        }
      });
      this.fetching = false;
    },

    
    getPromocoes() {
      this.fetching = true;
      getUserPromocoes(this.token).then((res) => {
        if (res.code === 200) { 
          this.promocoes = res.data 
        }
        else { 
          this.promocoes = null;
          this.error = "Ups! Something went wrong..."
        }
      });
      this.fetching = false;
    },

    changeVistoNotificacao(notifID: number) {
      this.fetching = true;
      eliminaNotificacao(this.token, notifID).then((res) => {
        if (res.code === 200) { 
          this.notificacoes = res.data;
        }
        else { 
          this.notificacoes = null;
          this.error = "Ups! Something went wrong..."
        }
      });
      this.fetching = false;
    },

    checkEspecialista() {
      if (this.loggedIn) {
        let e = this.getUtilizadorEncargo()
        if (e) return /especialista/gi.test(e.toString());
        else return false;
      }
      else return false;
    },

    checkAdmin() {
      if (this.loggedIn) {
        let e = this.getUtilizadorEncargo()
        if (e) return /admin/gi.test(e.toString());
        else return false;
      }
      else return false;
    },

    checkApostador() {
      if (this.loggedIn) {
        let e = this.getUtilizadorEncargo()
        if (e) return /apostador/gi.test(e.toString());
        else return false;
      }
      else return false;
    },

    getAdminApostas () {
      if (this.checkAdmin()) {
        this.fetching = true;
        getAdminApostas(this.token).then((res) => {
          if (res.code === 200) { 
            this.adminApostas = res.data 
            this.adminsApostasToShow = this.adminApostas
          }
          else { 
            this.adminApostas = null;
            this.adminsApostasToShow = null;
            this.error = "Ups! Something went wrong..."
          }
        });
        this.fetching = false;
      }
    },

    getAdminUsers () {
      if (this.checkAdmin()) {
        this.fetching = true;
        getAdminUsers(this.token).then((res) => {
          if (res.code === 200) { 
            this.adminUsers = res.data 
          }
          else { 
            this.adminUsers = null;
            this.error = "Ups! Something went wrong..."
          }
        });
        this.fetching = false;
      }
    },

    filterAdminApostasByGame (idGame: number) {
      if (this.adminApostas) {
        this.adminsApostasToShow = [];
        this.adminApostas.forEach((aposta) => {
            aposta.resultados.forEach((res) => {
              if (res.idjogo === idGame) {
                this.adminsApostasToShow?.push(aposta);
                return;
              }
            }) 
        })
      }
    },

    filterAdminApostasByUser (idUser: number) {
      if (this.adminApostas) {
        this.adminsApostasToShow = [];
        this.adminApostas.forEach((aposta) => {
          if (aposta.idUser === idUser) this.adminsApostasToShow?.push(aposta);
        })
      }
    },

    resetAdminApostas () {
      this.adminsApostasToShow = this.adminApostas
    },

    adminMudaEstadoAposta (idAposta: number, estado: string) {
      if (this.checkAdmin()) {
        return alteraEstadoApostaPOST(this.token, idAposta, estado);
      }
    },

    getAdminPromos () {
      if (this.checkAdmin()) {
        this.fetching = true;
        getAdminPromocoes(this.token).then((res) => {
          if (res.code === 200) { 
            this.adminPromos = res.data 
          }
          else { 
            this.adminPromos = null;
            this.error = "Ups! Something went wrong..."
          }
        });
        this.fetching = false;
      }
    },

    adminMudaEstadoPromo (idPromo: number) {
      if (this.checkAdmin()) {
        return alteraEstadoPromoPOST(this.token, idPromo);
      }
    },

    adminCriaPromo (msg: string) {
      if (this.checkAdmin()) {
        return criaPromocaoPOST(this.token, msg);
      }
    },

    apostadorSeguirJogo (idjogo: number, add: boolean) {
      if (this.checkApostador()) {
        this.fetching = true;
        
        seguirJogoPOST(this.token, idjogo, add).then((res) => {
          if (res.code === 200) {
            console.log(res.data.jogo);
            this.userJogos = res.data.jogo;
          }
          else this.error = "Ups! Something went wrong..."
        })

        this.fetching = false;
      }
    }


  },
});
