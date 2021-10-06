
export interface Patient {
    active?: boolean;
    birthday?: any;
    email?: string;
    fullName?: string;
    gender?: string;
    id?: string;
    mobileNumber?: string;
    name?: string;
    nic?: string;
    bloodGrp?: string;
    medicalDescription?: string;
    proPic?:string;
}

// patient obj in doc collection
export interface Doctor_Patient{
    email?: string;
    mobileNumber?: string;
    name?: string;
    pid?: string;
    status?: string;
    nic?: string;
}


