import { createRouter, createWebHistory } from "vue-router";

const router = createRouter({
  history: createWebHistory(),
  routes: [
    {
      path: "/",
      component: () => import("./views/HomePage.vue"),
      name: "home",
    },
    {
      path: "/login",
      component: () => import("./views/LoginPage.vue"),
      name: "login",
      beforeEnter: (to, from, next) => {
        if (localStorage.getItem('rasbetLoginToken') && localStorage.getItem('rasbetLoginToken')?.length !== 0) next('/')
        else next()
      },
    },
    {
      path: "/profile",
      component: () => import("./views/Profile.vue"),
      name: "profile",
      beforeEnter: (to, from, next) => {
        if (!localStorage.getItem('rasbetLoginToken') || localStorage.getItem('rasbetLoginToken')?.length === 0) next('/')
        else next()
      },
    },
    {
      path: "/register",
      component: () => import("./views/Register.vue"),
      name: "register",
      beforeEnter: (to, from, next) => {
        if (localStorage.getItem('rasbetLoginToken') && localStorage.getItem('rasbetLoginToken')?.length !== 0) next('/')
        else next()
      },
    },
    {
      path: "/admin/apostas",
      component: () => import("./views/AdminApostas.vue"),
      name: "admin-apostas",
      beforeEnter: (to, from, next) => {
        if (!localStorage.getItem('rasbetLoginToken') || localStorage.getItem('rasbetLoginToken')?.length === 0) next('/')
        else next()
      },
    },
    {
      path: "/admin/jogos",
      component: () => import("./views/AdminJogos.vue"),
      name: "admin-jogos",
      beforeEnter: (to, from, next) => {
        if (!localStorage.getItem('rasbetLoginToken') || localStorage.getItem('rasbetLoginToken')?.length === 0) next('/')
        else next()
      },
    },
    {
      path: "/admin/promos",
      component: () => import("./views/AdminPromos.vue"),
      name: "admin-promos",
      beforeEnter: (to, from, next) => {
        if (!localStorage.getItem('rasbetLoginToken') || localStorage.getItem('rasbetLoginToken')?.length === 0) next('/')
        else next()
      },
    },
    {
      path: "/admin/contas",
      component: () => import("./views/AdminContas.vue"),
      name: "admin-contas",
      beforeEnter: (to, from, next) => {
        if (!localStorage.getItem('rasbetLoginToken') || localStorage.getItem('rasbetLoginToken')?.length === 0) next('/')
        else next()
      },
    },
  ],
});

export default router;