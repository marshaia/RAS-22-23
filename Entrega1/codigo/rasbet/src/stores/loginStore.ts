import { defineStore } from "pinia";
import { User } from "../models/user";
import { mockUserList } from "../mockupDB/userList";

interface loginStore {
  loggedIn: boolean;
  error: string | null;
  user: User | null;
}

export const loginState = defineStore("login", {
  state: (): loginStore => {
    return {
      loggedIn: false,
      user: null,
      error: null,
    };
  },
  actions: {
    checkLogin() {
      let token = localStorage.getItem("loginToken") ?? "";
      if (token != "") {
        this.loggedIn = true;
        this.user =
          mockUserList.find((user) => user.email === JSON.parse(token)) ?? null;
        this.error = null;
      }
    },

    login(email: string, pass: string) {
      let mockUser = mockUserList.find((user) => user.email === email) ?? null;
      if (mockUser) {
        if (mockUser.password == pass) {
          this.user = mockUser;
          this.loggedIn = true;
          localStorage.setItem("loginToken", JSON.stringify(email));
        } else {
          this.loggedIn = false;
          this.user = null;
          this.error = "Password incorrect!";
        }
      } else {
        this.loggedIn = false;
        this.user = null;
        this.error = "Email not found!";
      }
    },

    logOut() {
      this.user = null;
      this.loggedIn = false;
      this.error = "";
      localStorage.removeItem("loginToken");
    },
  },
});
