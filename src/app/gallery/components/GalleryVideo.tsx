import GalleryCaption from './GalleryCaption';

interface Props {
  src: string;
  alt: string;
}

function GalleryVideo({ src, alt }: Props) {
  return (
    <div>
      <video
        loop
        autoPlay
        muted
        playsInline
        className="relative h-[600px] w-full overflow-hidden rounded object-cover"
      >
        <source src={src} type="video/mp4" />
      </video>
      <GalleryCaption>{alt}</GalleryCaption>
    </div>
  );
}

export default GalleryVideo;
