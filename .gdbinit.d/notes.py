class Local_Variables(Dashboard.Module):
    """Show the CPU registers and their values."""

    def __init__(self):
        self.local_var = []

    def label(self):
        return 'Local_Variables'

    def lines(self, term_width, style_changed):
        registers = []
        for reg_info in run('info local').strip().split('\n'):
            registers.append((reg_info))
            if (len(registers) > 20) :
                registers.append("etc .... ");
                break;
        #  out = registers.sort()
        out = registers
        return out
    
    def attributes(self):
        return {
            'divider': {
                'doc': 'Show Local Variables',
                'default': True,
                'type': bool
            }
        }
