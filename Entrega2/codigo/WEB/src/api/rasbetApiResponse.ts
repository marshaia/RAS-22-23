

export interface RasbetApiResponse{
    code:number,
    errorMsg: string | null,
    data: any | null,
}

export const genericGET = async (url : string, token? : any) : Promise<RasbetApiResponse> => {

    const resp = await fetch(url, {
        method: 'GET',
        headers: {
            "content-type": "application/json",
            "token": token ?? "",
        },
    })

    if (resp.ok){
        const obj = await resp.json()
        return {code: resp.status,errorMsg: "", data: obj}
    }
    else {
        return {code: resp.status ,errorMsg: resp.headers.get("message"), data: null}
    }
}


export const genericPOST = async (url : string, body:any) : Promise<RasbetApiResponse> => {

    const resp = await fetch(url, {
        method: 'POST',
        headers: {
            "content-type": "application/json"
        },
        body: JSON.stringify(body)
    })

    if (resp.ok){
        const obj = await resp.json()
        return {code: resp.status,errorMsg: "", data: obj}
    }
    else {
        return {code: resp.status ,errorMsg: resp.headers.get("message"), data: null}
    }
}