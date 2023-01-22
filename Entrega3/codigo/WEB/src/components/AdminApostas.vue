<template>
    <div class="shadow-xl rounded-2xl bg-white dark:bg-black py-3 px-8 h-full w-full">
        <div class="flex flex-col h-full">
            <div class="sticky top-0 z-10">
                <div class="text-xl font-semibold text-rasbet-logo-gold mb-2 pb-2 border-b-2 border-rasbet-logo-gold text-center">
                    Apostas
                </div>                
            </div>


            <div v-if="!login.adminApostas" class="flex flex-row justify-center mt-5"> <spiningButton /> </div>

            <div class="flex flex-col h-full">
                <div class="relative flex flex-col flex-grow h-0">
                    <div class="mt-2 overflow-auto no-scrollbar my-4 space-y-4">
                        <div v-for="aposta in login.adminsApostasToShow" :key="aposta.idaposta">
                            
                            <button @click.prevent="clickedAposta(aposta.idaposta)" class="w-full border hover:dark:bg-rasbet-view-black hover:bg-gray-100 p-3 dark:text-white text-black">

                                <div class="flex flex-row items-center">
                                
                                    <div class="text-rasbet-logo-gold font-semibold bg-rasbet-logo-gold rounded-md p-1 text-center text-sm">  
                                        <span v-if="aposta.simples" class="dark:text-white text-black"> SIMPLES </span>
                                        <span v-else class="dark:text-white text-black"> MÚLTIPLA </span>
                                    </div>

                                    <div class="grow text-gray-400 text-sm font-normal text-center">
                                        {{ aposta.data.split(" ")[0] }}
                                    </div>
                                        
                                    <div class="dark:text-white text-black">
                                        Estado: 
                                        <span class="font-semibold" :class="{'text-green-500' : /ganho/gi.test(aposta.estado) , 'text-red-600' : /perd/gi.test(aposta.estado), 'text-yellow-700' : /abert/gi.test(aposta.estado)}">
                                            {{aposta.estado}}
                                        </span>
                                    </div>

                                </div>

                                <div class="grow mt-2">
                                    <div v-for="items in aposta.resultados" class="justify-center text-center dark:text-white text-black">
                                        [
                                        <span class="dark:text-white text-black">{{items.hometeam}}</span>
                                        <template v-if="items.awayteam">
                                            <span class="text-rasbet-logo-gold mx-1">X</span>
                                            <span class="dark:text-white text-black">{{items.awayteam}}</span>
                                        </template>
                                        ]
                                        <span class="dark:text-white text-black ml-2"> (Apostou: </span>
                                        <span class="ml-1 text-rasbet-logo-gold"> {{items.nome}}</span>
                                        )
                                    </div>
                                </div>


                                <div class="flex flex-row items-center mt-2">
                                    <div class="grow text-sm text-left">
                                        <span class="text-rasbet-logo-gold">Autor: </span>
                                        <span class="text-black dark:text-white ml-1">{{ aposta.nomeuser }}</span>
                                    </div>

                                    <div class="text-md">
                                        Valor:
                                        <span class="text-rasbet-logo-gold">{{aposta.valor}}€</span>
                                    </div>
                                </div>

                            </button>
                        </div>
                        <BaseModalAdminAposta :is-open="openModal" :aposta="editAposta" @close="openModal=false" />
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script setup lang="ts">
import { ref } from 'vue';
import { loginState } from '../stores/loginStore';
import BaseModalAdminAposta from './BaseModalAdminAposta.vue'
import spiningButton from '../assets/spiningButton.vue';

const login = loginState();
login.getAdminApostas();

const openModal = ref<boolean>(false);
const editAposta = ref(0);

const clickedAposta = (idaposta: number) => {
    editAposta.value = idaposta;
    openModal.value = true;
}

</script>