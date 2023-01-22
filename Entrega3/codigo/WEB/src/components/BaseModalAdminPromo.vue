<template>
    <BaseModal @close="$emit('close')" title="Gerir Promoção" :is-open="isOpen">
        <div v-if="!done" class="mt-5 dark:text-white text-black text-center">
            Tem a certeza que pretende 
            <span v-if="ativa === 1"> desativar </span>
            <span v-else> ativar </span>
            a promoção?
        </div>

        <div v-if="!done" class="flex flex-row justify-center mt-8 items-center  space-x-6 text-center">

            <button
            type="button"
            @click.prevent="send()"
            class="w-20 rounded-md dark:bg-opacity-40 bg-opacity-60 bg-rasbet-logo-gold px-4 py-2 text-sm font-semibold text-white uppercase hover:bg-rasbet-logo-gold focus:outline-none focus-visible:ring-2 focus-visible:ring-white focus-visible:ring-opacity-75">         
                SIM
            </button>

            <button
            type="button"
            @click.prevent="$emit('close')"
            class="w-20 rounded-md dark:bg-opacity-40 bg-opacity-60 bg-rasbet-logo-gold px-4 py-2 text-sm font-semibold text-white uppercase hover:bg-rasbet-logo-gold focus:outline-none focus-visible:ring-2 focus-visible:ring-white focus-visible:ring-opacity-75">         
                NÃO
            </button>

       </div>

       <div v-if="done" class="text-green-500 text-md mt-8 text-center">
            Estado da promoção alterado com sucesso!
       </div>

       <div v-if="errorUploading" class="text-red-600 text-md text-center mt-8">
            Ocorreu um erro ao gravar as alterações, por favor tente novamente!
       </div>

    </BaseModal>
</template>

<script setup lang="ts">
import { ref } from 'vue';
import BaseModal from './BaseModal.vue'
import { loginState } from '../stores/loginStore'

interface Props {
   isOpen: boolean,
   promo: number,
   ativa: number,
}

interface Emits {
   (e: "close"): void;
}
 
const emit = defineEmits<Emits>();
const props = defineProps<Props>();

const login = loginState();
const done =  ref<boolean>(false);

const errorUploading = ref<boolean>(false);

const send = () => {

    errorUploading.value = false;

    login.adminMudaEstadoPromo(props.promo)?.then((res) => {
        if (res.code === 200) {
            login.getAdminPromos();
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
    },400);
    emit('close');
}

</script>