class Watch_Points(Dashboard.Module):
    """Show the CPU registers and their values."""

    def __init__(self):
        self.local_var = []

    def label(self):
        return 'Watch_Points'

    def lines(self, term_width, style_changed):
        registers = []
        for reg_info in run('info watch').strip().split('\n'):
            registers.append((reg_info))
        out = registers
        return out
    
    def attributes(self):
        return {
            'divider': {
                'doc': 'Show Watch Points',
                'default': True,
                'type': bool
            }
        }

