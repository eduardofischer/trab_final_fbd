import React from 'react'
import { CopyBlock as CB, a11yDark } from 'react-code-blocks'

const CodeBlock = props => (
  <div className="code-block">
    <CB
      text={props.text}
      language="sql"
      showLineNumbers
      theme={a11yDark}
      wrapLines
    />
  </div>
)

export default CodeBlock