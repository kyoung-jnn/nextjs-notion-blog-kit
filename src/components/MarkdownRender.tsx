import 'katex/dist/katex.min.css';

import ImageViewer from './ImageViewer';
import './MarkdownRender.css';

interface Props {
  html: string;
}

function MarkdownRender({ html }: Props) {
  return (
    <>
      <article className="markdown-render" dangerouslySetInnerHTML={{ __html: html }} />
      <ImageViewer />
    </>
  );
}

export default MarkdownRender;
