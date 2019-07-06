<!DOCTYPE html>
<html>
  <h1>LOAC</h1>
   <a><img src= "https://upload.wikimedia.org/wikipedia/en/thumb/e/ef/SystemVerilog_logo.png/240px-SystemVerilog_logo.png" alt="Logo"></a>
  </head>
  <main>
    <section>
      <p><strong>SystemVerilog</strong> é uma linguagem de verificação de hardware e descrição usada para modelar, projetar, simular, testar e implementar sistemas eletrônicos
      </p>
      <code>Observação:
        
          Assíncrono (não segue o clock):

          always_ff @(posedge clock or posedge reset) begin
                if(reset) begin
                ...
                end else begin
                ...
                end
          end
          
          /***************************************************/

          Síncrono (segue o clock):

          always_ff @(posedge clock) begin
                if(reset) begin
                ...
                end else begin
                ...
                end
          end
   </code> 
   </p>
   </section>
</html>
