import { defineStore } from "pinia";
import { User } from "../models/user";
import { Notificacao } from '../models/notificacoes'
import { HistoricoAposta, HistoricoTrasacao } from "../models/historicos";
import { getTransactions, getApostas, getEspecialistaResultados, getUserNotificacoes } from "../api/rasbetGETApi";
import { editProfilePOST, getUserPOST, loginPOST, logoutPOST, registerUserPOST, eliminaNotificacao } from "../api/rasbetPOSTApi";
import { RasbetApiResponse } from "../api/rasbetApiResponse";

interface loginStore {
  loggedIn: boolean;
  fetching: boolean
  error: string | null;
  user: User | null;
  transacoes: [HistoricoTrasacao] | null;
  apostas: [HistoricoAposta] | null;
  especialistaResultados: [] | null;
  notificacoes: [Notificacao] | null
  token: string,
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
      token: "",
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
        this.loggedIn = true;
        this.error = null;
      }
      else{
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
        //this.token = this.user?.token ?? "" ;
        //localStorage.setItem("rasbetLoginToken", JSON.stringify(this.token));
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
                   cc: string, endereco: string, telefone: number, tipo: string) : Promise<boolean> {
      this.fetching = true
      const res = await registerUserPOST(email,pass,nome,datanascimento,nif,cc,endereco,telefone,tipo);
      this.fetching = false;

      return this.setUserAndToken(res);
    },

    getEspecialistaResultados() {
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

    // está feito para receber a lista de notificações updated
    eliminaNotificacao(notifID: number) {
      this.fetching = true;
      eliminaNotificacao(this.token, notifID).then((res) => {
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
    }
  },
});
