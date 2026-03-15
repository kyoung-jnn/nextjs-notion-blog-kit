import 'katex/dist/katex.min.css';

import './MarkdownRender.css';

interface Props {
  html: string;
}

function MarkdownRender({ html }: Props) {
  return <article className="markdown-render" dangerouslySetInnerHTML={{ __html: html }} />;
}

export default MarkdownRender;
