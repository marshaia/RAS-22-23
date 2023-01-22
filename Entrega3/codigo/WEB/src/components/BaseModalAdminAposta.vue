<template>
    <BaseModal @close="$emit('close')" title="Gerir Aposta" :is-open="isOpen">
        <div v-if="!done" class="mt-5 dark:text-white text-black text-center">
            Por favor selecione o novo estado da aposta:
        </div>

        <div v-if="!done" class="flex flex-row justify-center mt-8 items-center text-center">
            
            <div>
                <select v-model="novoEstado" class="w-40 mr-10 rounded-md text-center ml-3 dark:text-white text-black font-normal border text text-sm px-3 py-2 dark:bg-rasbet-view-black">
                    <option value="Aberta"> Aberta </option>
                    <option value="Suspensa"> Suspensa </option>
                    <option value="Ganhou"> Ganhou </option>
                    <option value="Perdeu"> Perdeu </option>
                </select>                
            </div>

        
            <button
            type="button"
            @click.prevent="send()"
            class="w-32 rounded-md dark:bg-opacity-40 bg-opacity-60 bg-rasbet-logo-gold px-4 py-2 text-sm font-semibold text-white uppercase hover:bg-rasbet-logo-gold focus:outline-none focus-visible:ring-2 focus-visible:ring-white focus-visible:ring-opacity-75">         
                ALTERAR
            </button>

       </div>

       <div v-if="done" class="text-green-500 text-md mt-8 text-center">
            Estado da aposta alterado com sucesso!
       </div>

       <div v-if="errorUploading" class="text-red-600 text-md text-center mt-8">
            Ocorreu um erro ao gravar as alterações, por favor tente novamente!
       </div>

       <div v-if="errorEstadoNull" class="text-red-600 text-md text-center mt-8">
            Por favor selecione um estado!
       </div>

    </BaseModal>
</template>

<script setup lang="ts">
import { ref } from 'vue';
import BaseModal from './BaseModal.vue'
import { loginState } from '../stores/loginStore'

interface Props {
   isOpen: boolean,
   aposta: number,
}

interface Emits {
   (e: "close"): void;
}
 
const emit = defineEmits<Emits>();
const props = defineProps<Props>();

const login = loginState();
const done =  ref<boolean>(false);
const novoEstado = ref<string>()

const errorUploading = ref<boolean>(false);
const errorEstadoNull = ref<boolean>(false);

const send = () => {

    if(!novoEstado.value) {
        errorEstadoNull.value = true;
        return;
    }

    errorUploading.value = false;
    errorEstadoNull.value = false;

    login.adminMudaEstadoAposta(props.aposta, novoEstado.value)?.then((res) => {
        if (res.code === 200) {
            login.getAdminApostas();
            done.value = true;
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
        errorEstadoNull.value = false;
        novoEstado.value = "";
    },400);
    emit('close');
}
</script>