<template>
    <div class="shadow-xl rounded-2xl bg-white dark:bg-black py-3 px-8 h-full w-full">
        <div class="flex flex-col h-full">
            <div class="text-xl font-semibold text-rasbet-logo-gold mb-2 pb-2 border-b-2 border-rasbet-logo-gold text-center">
                Criar Promoção
            </div>

            <div class="flex flex-col h-full">
                <div class="relative flex flex-col flex-grow h-0">
                        
                        <form id="desc" @submit.prevent="formSubmit()" class=" mt-20">
                            <label 
                            for="descricao"
                            class="mb-2 block text-lg font-semibold text-rasbet-logo-gold">
                                Descrição:
                            </label>
                            <textarea 
                            id="descricao"
                            v-model="descricao"
                            maxlength="256"
                            type="text"
                            class="w-full mt-2 h-72 dark:text-white text-black dark:bg-rasbet-view-black bg-gray-100 border dark:border-white border-gray-300 p-4 focus:outline-none"
                            placeholder="Descrição da Promoção"
                            required 
                            >
                            </textarea>

                            <div class="flex grow justify-center items-center mt-20">
                                <button
                                form="desc"
                                type="submit"
                                @submit.prevent="formSubmit()"
                                class="mb-1.5 block w-36 text-center text-white bg-rasbet-logo-gold hover:bg-yellow-500 px-2 py-1.5 rounded-md">
                                    <span v-if="login.fetching"> <spiningButtonVue/> </span>
                                    <span v-else>CRIAR</span>
                                </button>
                            </div>
                        </form>

                        <BaseModalAdminCriarPromo  :msg="modalString" :is-open="openModal" @close="openModal=false" />
                </div>
            </div>
        </div>
    </div>
</template>

<script setup lang="ts">
import { ref } from 'vue';
import spiningButtonVue from "../assets/spiningButton.vue";
import { loginState } from '../stores/loginStore'
import BaseModalAdminCriarPromo from './BaseModalAdminCriarPromo.vue'

const login = loginState();

const descricao = ref<string>();
const openModal = ref<boolean>(false);
const errorDescricaoNull = ref<boolean>(false);
const modalString = ref<string>("");

const formSubmit = () => {
    if(!descricao.value) {
        errorDescricaoNull.value = true;
        return;
    }

    else {
        errorDescricaoNull.value = false;
        modalString.value = descricao.value
        openModal.value = true;
    }
}
</script>


<style>
    textarea {
        resize: none;
    }
</style>