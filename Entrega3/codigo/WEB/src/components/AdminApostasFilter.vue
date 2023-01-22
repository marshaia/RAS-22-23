<template>
    <div class="shadow-xl rounded-2xl bg-white dark:bg-black py-3 px-8 h-full w-full">
        <div class="flex flex-col space-y-6 h-full">
            <AdminApostasFiltroJogo />
            <div class="flex-grow"></div>
            <AdminApostasFilterUsers />
        </div>
    </div>
</template>

<script setup lang="ts">
import AdminApostasFilterUsers from './AdminApostasFilterUsers.vue';
import AdminApostasFiltroJogo from './AdminApostasFiltroJogo.vue';
</script>