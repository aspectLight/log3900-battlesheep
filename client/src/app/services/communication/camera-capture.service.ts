import { ElementRef, Injectable } from '@angular/core';

@Injectable({
    providedIn: 'root',
})
export class CameraCaptureService {
    showCameraModal = false;
    cameraStream: MediaStream | null = null;
    capturedImageDataUrl: string | null = null;
    cameraError: string | null = null;
    isCameraReady = false;

    reset() {
        this.cameraError = null;
        this.capturedImageDataUrl = null;
        this.isCameraReady = false;
    }

    async startStream(): Promise<void> {
        if (!navigator.mediaDevices?.getUserMedia) {
            this.cameraError = "Votre navigateur ne supporte pas l'accès à la caméra.";
            this.showCameraModal = false;
            return;
        }

        try {
            this.cameraStream = await navigator.mediaDevices.getUserMedia({ video: { facingMode: 'user' }, audio: false });
        } catch (err: unknown) {
            const error = err as { name?: string };
            if (error?.name === 'NotAllowedError' || error?.name === 'PermissionDeniedError') {
                this.cameraError = "Accès à la caméra refusé. Veuillez autoriser l'accès dans les paramètres de votre navigateur.";
            } else if (error?.name === 'NotFoundError' || error?.name === 'DevicesNotFoundError') {
                this.cameraError = 'Aucune caméra détectée sur votre appareil.';
            } else {
                this.cameraError = "Impossible d'accéder à la caméra. Veuillez réessayer.";
            }
            this.showCameraModal = false;
        }
    }

    attachStream(videoRef: ElementRef<HTMLVideoElement>) {
        if (videoRef?.nativeElement && this.cameraStream) {
            videoRef.nativeElement.srcObject = this.cameraStream;
            this.isCameraReady = true;
        }
    }

    capturePhoto(videoRef: ElementRef<HTMLVideoElement>, canvasRef: ElementRef<HTMLCanvasElement>) {
        const video = videoRef?.nativeElement;
        const canvas = canvasRef?.nativeElement;
        if (!video || !canvas) return;

        canvas.width = video.videoWidth;
        canvas.height = video.videoHeight;
        const ctx = canvas.getContext('2d');
        if (!ctx) return;

        ctx.translate(canvas.width, 0);
        ctx.scale(-1, 1);
        ctx.drawImage(video, 0, 0, canvas.width, canvas.height);

        this.capturedImageDataUrl = canvas.toDataURL('image/jpeg', 0.9);
        this.stopStream(videoRef);
    }

    dataUrlToFile(dataUrl: string): File {
        const byteString = atob(dataUrl.split(',')[1]);
        const ab = new ArrayBuffer(byteString.length);
        const ia = new Uint8Array(ab);
        for (let i = 0; i < byteString.length; i++) {
            ia[i] = byteString.charCodeAt(i);
        }
        const blob = new Blob([ab], { type: 'image/jpeg' });
        return new File([blob], `selfie-${Date.now()}.jpg`, { type: 'image/jpeg' });
    }

    closeCamera(videoRef?: ElementRef<HTMLVideoElement>) {
        this.stopStream(videoRef);
        this.showCameraModal = false;
        this.capturedImageDataUrl = null;
        this.cameraError = null;
        this.isCameraReady = false;
    }

    stopStream(videoRef?: ElementRef<HTMLVideoElement>) {
        if (this.cameraStream) {
            this.cameraStream.getTracks().forEach((track) => track.stop());
            this.cameraStream = null;
        }
        if (videoRef?.nativeElement) {
            videoRef.nativeElement.srcObject = null;
        }
        this.isCameraReady = false;
    }
}
