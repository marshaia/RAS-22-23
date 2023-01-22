<template>
     <BaseModal @close="$emit('close')" :title="title ?? 'Erro'" :is-open="isOpen">
        <div class="mt-5 dark:text-white text-black text-center">
            Tem de ter 
            <button @click.prevent="router.push({name: 'login'})" class="text-rasbet-logo-gold underline">sessão iniciada</button>
            para efetuar apostas!
        </div>
     </BaseModal>
</template>

<script setup lang="ts">
import BaseModal from './BaseModal.vue'
import { useRouter } from 'vue-router'

const router = useRouter();

interface Props {
    title?: string,
    isOpen: boolean,
}

interface Emits {
    (e: "close"): void;
}
  
defineEmits<Emits>();
defineProps<Props>();
</script>