<template>
    <div class="shadow-xl rounded-2xl bg-white dark:bg-black py-3 px-8 h-full w-full">
        <div class="flex flex-col h-full">
            <div class="text-xl font-semibold text-rasbet-logo-gold mb-2 pb-2 border-b-2 border-rasbet-logo-gold text-center">
                Promoções
            </div>
            <div class="flex flex-col h-full">
                <div class="relative flex flex-col flex-grow h-0">
                    <div class="mt-2 overflow-auto no-scrollbar my-4 space-y-4">
                        <template v-for="promocao in login.adminPromos" :key="promocao.idpromocao">
                            <button @click.prevent="clickedPromo(promocao.idpromocao, promocao.ativa)" class="flex flex-row w-full border hover:dark:bg-rasbet-view-black hover:bg-gray-100 p-3 dark:text-white text-black">
                                
                                <div class="w-24 h-8 dark:text-black text-white font-semibold rounded-md p-1 text-center text-sm"
                                :class="promocao.ativa === 1 ? 'bg-green-500' : 'bg-red-500'">  
                                    <span v-if="promocao.ativa === 1" class=""> ATIVA </span>
                                    <span v-else class=""> DESATIVADA </span>
                                </div>
                                
                                <div class="ml-2 text-lg dark:text-white text-black">
                                    <span class="font-semibold">Descrição: </span>
                                    {{ promocao.descricao }}
                                </div>
                            
                            </button>
                        </template>
                        <BaseModalAdminPromo :is-open="openModal" :promo="promoID" :ativa="ativa" @close="openModal=false"/>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script setup lang="ts">
import { ref } from 'vue';
import BaseModalAdminPromo from './BaseModalAdminPromo.vue';
import { loginState } from '../stores/loginStore'

const login = loginState();
login.getAdminPromos();

const openModal = ref<boolean>(false);
const promoID = ref(0);
const ativa = ref(0);

const clickedPromo = (idpromo: number, active: number) => {
    promoID.value = idpromo;
    ativa.value = active;
    openModal.value = true;
}

</script>