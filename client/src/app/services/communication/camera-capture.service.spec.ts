import { ElementRef } from '@angular/core';
import { TestBed } from '@angular/core/testing';
import { CameraCaptureService } from './camera-capture.service';

const makeVideoRef = (overrides: Partial<HTMLVideoElement> = {}): ElementRef<HTMLVideoElement> => ({
    nativeElement: { srcObject: null, videoWidth: 640, videoHeight: 480, ...overrides } as HTMLVideoElement,
});

const makeCanvasRef = (): ElementRef<HTMLCanvasElement> => {
    const ctx = {
        translate: jasmine.createSpy('translate'),
        scale: jasmine.createSpy('scale'),
        drawImage: jasmine.createSpy('drawImage'),
    };
    const canvas = {
        width: 0,
        height: 0,
        getContext: jasmine.createSpy('getContext').and.returnValue(ctx),
        toDataURL: jasmine.createSpy('toDataURL').and.returnValue('data:image/jpeg;base64,AAAA'),
    } as unknown as HTMLCanvasElement;
    return { nativeElement: canvas };
};

describe('CameraCaptureService', () => {
    let service: CameraCaptureService;

    beforeEach(() => {
        TestBed.configureTestingModule({});
        service = TestBed.inject(CameraCaptureService);
    });

    it('should be created', () => {
        expect(service).toBeTruthy();
    });

    describe('initial state', () => {
        it('should have all flags set to false/null', () => {
            expect(service.showCameraModal).toBeFalse();
            expect(service.cameraStream).toBeNull();
            expect(service.capturedImageDataUrl).toBeNull();
            expect(service.cameraError).toBeNull();
            expect(service.isCameraReady).toBeFalse();
        });
    });

    describe('reset()', () => {
        it('should clear error, capturedImage and isCameraReady', () => {
            service.cameraError = 'some error';
            service.capturedImageDataUrl = 'data:image/jpeg;base64,AAAA';
            service.isCameraReady = true;

            service.reset();

            expect(service.cameraError).toBeNull();
            expect(service.capturedImageDataUrl).toBeNull();
            expect(service.isCameraReady).toBeFalse();
        });

        it('should not affect showCameraModal', () => {
            service.showCameraModal = true;
            service.reset();
            expect(service.showCameraModal).toBeTrue();
        });
    });

    describe('startStream()', () => {
        it('should set error and close modal when getUserMedia is not supported', async () => {
            const originalMediaDevices = navigator.mediaDevices;
            Object.defineProperty(navigator, 'mediaDevices', { value: undefined, configurable: true });

            await service.startStream();

            expect(service.cameraError).toBeTruthy();
            expect(service.showCameraModal).toBeFalse();

            Object.defineProperty(navigator, 'mediaDevices', { value: originalMediaDevices, configurable: true });
        });

        it('should set stream when getUserMedia succeeds', async () => {
            const mockStream = { getTracks: () => [] } as unknown as MediaStream;
            spyOn(navigator.mediaDevices, 'getUserMedia').and.returnValue(Promise.resolve(mockStream));

            await service.startStream();

            expect(service.cameraStream).toBe(mockStream);
            expect(service.cameraError).toBeNull();
        });

        it('should set error and close modal on NotAllowedError', async () => {
            const error = { name: 'NotAllowedError' };
            spyOn(navigator.mediaDevices, 'getUserMedia').and.returnValue(Promise.reject(error));

            await service.startStream();

            expect(service.cameraError).toContain('refusé');
            expect(service.showCameraModal).toBeFalse();
        });

        it('should set error and close modal on NotFoundError', async () => {
            const error = { name: 'NotFoundError' };
            spyOn(navigator.mediaDevices, 'getUserMedia').and.returnValue(Promise.reject(error));

            await service.startStream();

            expect(service.cameraError).toContain('caméra détectée');
            expect(service.showCameraModal).toBeFalse();
        });

        it('should set generic error on unknown error', async () => {
            spyOn(navigator.mediaDevices, 'getUserMedia').and.returnValue(Promise.reject({ name: 'UnknownError' }));

            await service.startStream();

            expect(service.cameraError).toContain("Impossible d'accéder");
            expect(service.showCameraModal).toBeFalse();
        });
    });

    describe('attachStream()', () => {
        it('should set srcObject and mark camera as ready when stream exists', () => {
            const mockStream = { getTracks: () => [] } as unknown as MediaStream;
            service.cameraStream = mockStream;
            const videoRef = makeVideoRef();

            service.attachStream(videoRef);

            expect(videoRef.nativeElement.srcObject).toBe(mockStream);
            expect(service.isCameraReady).toBeTrue();
        });

        it('should not mark camera as ready when stream is null', () => {
            service.cameraStream = null;
            const videoRef = makeVideoRef();

            service.attachStream(videoRef);

            expect(service.isCameraReady).toBeFalse();
        });
    });

    describe('capturePhoto()', () => {
        it('should set capturedImageDataUrl and stop the stream', () => {
            const mockTrack = { stop: jasmine.createSpy('stop') };
            const mockStream = { getTracks: () => [mockTrack] } as unknown as MediaStream;
            service.cameraStream = mockStream;

            const videoRef = makeVideoRef();
            const canvasRef = makeCanvasRef();

            service.capturePhoto(videoRef, canvasRef);

            expect(service.capturedImageDataUrl).toBe('data:image/jpeg;base64,AAAA');
            expect(mockTrack.stop).toHaveBeenCalled();
            expect(service.cameraStream).toBeNull();
        });

        it('should do nothing if videoRef or canvasRef is missing', () => {
            service.capturePhoto(null as unknown as ElementRef<HTMLVideoElement>, null as unknown as ElementRef<HTMLCanvasElement>);
            expect(service.capturedImageDataUrl).toBeNull();
        });
    });

    describe('dataUrlToFile()', () => {
        it('should return a File with jpeg type', () => {
            const canvas = document.createElement('canvas');
            canvas.width = 1;
            canvas.height = 1;
            const dataUrl = canvas.toDataURL('image/jpeg');

            const file = service.dataUrlToFile(dataUrl);

            expect(file).toBeInstanceOf(File);
            expect(file.type).toBe('image/jpeg');
            expect(file.name).toMatch(/^selfie-\d+\.jpg$/);
        });
    });

    describe('closeCamera()', () => {
        it('should reset all state and stop the stream', () => {
            const mockTrack = { stop: jasmine.createSpy('stop') };
            const mockStream = { getTracks: () => [mockTrack] } as unknown as MediaStream;
            service.cameraStream = mockStream;
            service.showCameraModal = true;
            service.capturedImageDataUrl = 'data:image/jpeg;base64,AAAA';
            service.cameraError = 'some error';
            service.isCameraReady = true;

            const videoRef = makeVideoRef();
            service.closeCamera(videoRef);

            expect(service.showCameraModal).toBeFalse();
            expect(service.capturedImageDataUrl).toBeNull();
            expect(service.cameraError).toBeNull();
            expect(service.isCameraReady).toBeFalse();
            expect(service.cameraStream).toBeNull();
            expect(mockTrack.stop).toHaveBeenCalled();
        });
    });

    describe('stopStream()', () => {
        it('should stop all tracks and null out cameraStream', () => {
            const mockTrack = { stop: jasmine.createSpy('stop') };
            const mockStream = { getTracks: () => [mockTrack] } as unknown as MediaStream;
            service.cameraStream = mockStream;

            service.stopStream();

            expect(mockTrack.stop).toHaveBeenCalled();
            expect(service.cameraStream).toBeNull();
            expect(service.isCameraReady).toBeFalse();
        });

        it('should clear srcObject on videoRef if provided', () => {
            const videoRef = makeVideoRef({ srcObject: {} as MediaStream });
            service.stopStream(videoRef);
            expect(videoRef.nativeElement.srcObject).toBeNull();
        });
    });
});
