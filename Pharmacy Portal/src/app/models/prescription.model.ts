// prescription obj
export interface Prescription{
    id?: string;
    docId?: string;
    docName?: string;
    patientId?: string;
    patientName?: string;
    prescription?: string;
    repeat?: boolean;
    expDate?: any;
    status?: string;
    createdAt?: any;
}