<template>
    <BaseModal @close="$emit('close')" title="Criar Jogo" :is-open="isOpen">
        <div v-if="!done" class="mt-5 dark:text-white text-black text-center">
            Tem a certeza que pretende criar o jogo?
        </div>

        <div v-if="!done" class="flex flex-row mt-8 space-x-6 justify-center">
            <button
            type="button"
            @click="send()"
            class="w-20 rounded-md dark:bg-opacity-40 bg-opacity-60 bg-rasbet-logo-gold px-4 py-2 text-sm font-semibold text-white uppercase hover:bg-rasbet-logo-gold focus:outline-none focus-visible:ring-2 focus-visible:ring-white focus-visible:ring-opacity-75">         
                SIM
            </button>

            <button
            type="button"
            @click="$emit('close')"
            class="w-20 rounded-md dark:bg-opacity-40 bg-opacity-60 bg-rasbet-logo-gold px-4 py-2 text-sm font-semibold text-white uppercase hover:bg-rasbet-logo-gold focus:outline-none focus-visible:ring-2 focus-visible:ring-white focus-visible:ring-opacity-75">         
                NÃO
            </button>
       </div>

       <div v-if="done" class="text-green-500 text-md mt-8 text-center">
            Jogo criado com sucesso!
       </div>

       <div v-if="errorUploading" class="text-red-600 text-md text-center mt-8">
            Ocorreu um erro ao criar o jogo, por favor tente novamente!
       </div>

    </BaseModal>
</template>

<script setup lang="ts">
import { ref } from 'vue';
import BaseModal from './BaseModal.vue'
import { gameState } from '../stores/gameStore'
import { loginState } from '../stores/loginStore'
import { gameToSend } from '../models/rasbetJogo'

interface Props {
   isOpen: boolean,
   jogo: gameToSend | null,
}

interface Emits {
   (e: "close"): void;
}
 
const emit = defineEmits<Emits>();
const props = defineProps<Props>();

const games = gameState();
const login = loginState();
const errorUploading = ref<boolean>(false);
const done =  ref<boolean>(false);

const send = () => {
    errorUploading.value = false;
    games.adminCriaJogo(login.token, props.jogo ?? mockGame).then((res) => {
        if (res.code === 200) {
            done.value = true;
            games.getAllGames(true);
            setTimeout(games.showAllGames, 50);
            setTimeout(exit, 1000);
        }
        else {
            errorUploading.value = true;
            done.value = false;
            return;
        }
    })
}

const exit = () => {
    setTimeout(() => {
        done.value = false;
        errorUploading.value = false;
    },400);

    emit('close');
}

const mockGame =  {
    iddesporto: 0,
    idcompeticao: 0,
    homeTeam: null,
    awayTeam: null,
    starttime:"",
    completed: false,
    resultados: [],
}

</script>